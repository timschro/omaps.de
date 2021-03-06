var boundsGermany = [[
    5.98865807458,
    47.3024876979
], [
    15.0169958839,
    54.983104153
]];

var searchMaps = [];

var mapJson = [];

var defaultDetailZoom = 13;

var loadingSpinner = function (on) {
    var spinnerEl = $('#spinner');
    var backgroundEl = $('#loading-background');

    if (on) {
        spinnerEl.addClass('loading');
        backgroundEl.addClass('absolute');
        backgroundEl.removeClass('none');
    } else {
        spinnerEl.removeClass('loading');
        backgroundEl.removeClass('absolute');
        backgroundEl.addClass('none');
    }
};

var loadSearchMaps = function () {
    $.ajax({
        type: 'GET',
        url: searchUrl,
        dataType: 'json',
        timeout: 2000,
        success: function (data) {
            console.log("Search base loaded.")
            searchMaps = data.features;

            // Add geolocate control to the map.
            map.addControl(new mapboxgl.GeolocateControl({
                positionOptions: {
                    enableHighAccuracy: true
                },
                fitBoundsOptions: {
                    maxZoom: 12
                },
                trackUserLocation: true
            }), 'bottom-right');
        },
        error: function (xhr, type) {
            console.log("Error! Search base not loaded!", type);
        }
    })
};

var afterChangeComplete = function (e) {
    if (!map.loaded()) {
        return
    } // still not loaded; bail out.
    if (e.target && e.target.loaded()) {
        console.log("afterChangeComplete");
        loadSearchMaps();
        loadingSpinner(false);
        if (deeplink === true) {
            console.log(center)
            map.flyTo({center: center, zoom: defaultDetailZoom});
            populateMapDetails(mapId);
        } else {
            map.fitBounds(boundsGermany);
        }
        map.off('render', afterChangeComplete)
    }
};

$(document).ready(function () {
    console.log("Document ready");

    loadingSpinner(true);

});

var omapsGeocoder = function (query) {
    if (query.length < 3) {
        return null;
    }
    var hits = [];

    for (var i = 0; i < searchMaps.length; i++) {
        var feature = searchMaps[i]
        if (feature.text.toLowerCase().includes(query.toLowerCase().replace('karte: ', ''))) {
            feature.place_name = "Karte: " + feature.text
            feature.place_type = ["place"];
            hits.push(feature);
            if(hits.length > 10) { break; }
        }
    }
    return hits;
};


var omapsGeocoderFilter = function (geojson) {
    if(geojson.place_type.includes('region') || geojson.place_type.includes('place')) {
        return true;
    } else {
        return false;
    }
};

function populateMapDetails(mapId) {

    var source = document.getElementById("entry-template").innerHTML;
    var template = Handlebars.compile(source);


        if (map.getLayer("selectedFeature")) {
            map.removeLayer("selectedFeature");
        }
        if (map.getSource("selectedFeature")) {
            map.removeSource("selectedFeature");
        }






    $.ajax({
        type: 'GET',
        url: detailUrl.replace('mapId', mapId),
        dataType: 'json',
        timeout: 1000,
        success: function (data) {
            $("#entry").html(template(data.properties));
            $("#entry").show();

            map.addSource('selectedFeature', {
                "type":"geojson",
                "data": data
            });
            map.addLayer({
                id: "selectedFeature",
                source: "selectedFeature",
                type: "circle",
                paint: {
                    "circle-color": "#fff",
                    "circle-radius": 12,
                    "circle-stroke-width": 2,
                    "circle-stroke-color": "#fd207e"
                }
            });


            $("#hideButton").on('click', function (e) {
                $("#entry").hide();

                if (map.getLayer("selectedFeature")) {
                    map.removeLayer("selectedFeature");
                }
                if (map.getSource("selectedFeature")) {
                    map.removeSource("selectedFeature");
                }

            });
        },
        error: function (xhr, type) {
            console.log("Error! Could not load details.", type);
        }
    });
}

map.on('load', function () {
    console.log("Map ready");
    map.on('render', afterChangeComplete);



    map.addSource('maps', {
        type: 'geojson',
        data: url,
        cluster: true,
        clusterMaxZoom: 13, // Max zoom to cluster points on
        clusterRadius: 50 // Radius of each cluster when clustering points (defaults to 50)
    });


    map.addLayer({
        id: "clusters",
        type: "circle",
        source: "maps",
        filter: ["has", "point_count"],
        paint: {
            "circle-color": {
                property: "point_count",
                type: "interval",
                stops: [
                    [0, "#51bbd6"],
                    [100, "#f1f075"],
                    [750, "#f28cb1"],
                ]
            },
            "circle-radius": {
                property: "point_count",
                type: "interval",
                stops: [
                    [0, 20],
                    [100, 30],
                    [750, 40]
                ]
            }
        }
    });

    map.addLayer({
        id: "cluster-count",
        type: "symbol",
        source: "maps",
        filter: ["has", "point_count"],
        layout: {
            "text-field": "{point_count_abbreviated}",
            "text-font": ["DIN Offc Pro Medium", "Arial Unicode MS Bold"],
            "text-size": 12
        }
    });

    map.addLayer({
        id: "unclustered-point",
        type: "circle",
        source: "maps",
        filter: ["!has", "point_count"],
        paint: {
            "circle-color": "#fd20  7e",
            "circle-radius": 10,
            "circle-stroke-width": 2,
            "circle-stroke-color": "#fff"
        }
    });

    map.on('click', 'cluster-count', function (e) {
        var features = map.queryRenderedFeatures(e.point, {layers: ['clusters']});
        var clusterId = features[0].properties.cluster_id;
        map.getSource('maps').getClusterExpansionZoom(clusterId, function (err, zoom) {
            if (err)
                return;
            map.easeTo({
                center: features[0].geometry.coordinates,
                zoom: zoom
            });
        });
    });

    map.on('click', 'unclustered-point', function (e) {
        map.flyTo({center: e.features[0].geometry.coordinates});
        populateMapDetails(e.features[0].properties.id);
    });

    map.dragRotate.disable();
    map.touchZoomRotate.disableRotation();

    var popup = new mapboxgl.Popup({
        closeButton: false,
        closeOnClick: true
    });

    map.on('mouseenter', 'unclustered-point', function (e) {

        if (Modernizr.touchevents) {
            // Touch devise, don't handle mouseenter
        } else {

            map.getCanvas().style.cursor = 'pointer';

            var sourcePopup = document.getElementById("popup-template").innerHTML;
            var templatePopup = Handlebars.compile(sourcePopup);

            var data = {
                title: e.features[0].properties.name,
                year: e.features[0].properties.year,
                club: e.features[0].properties.club,
                type: e.features[0].properties.type,
                discipline: e.features[0].properties.discipline
            };
            var coordinates = e.features[0].geometry.coordinates.slice();
            var description = templatePopup(data);

            while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
                coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
            }
            popup.setLngLat(coordinates)
                .setHTML(description)
                .addTo(map);
        }



    });

    map.on('mouseleave', 'unclustered-point', function () {
        map.getCanvas().style.cursor = '';
        popup.remove();
    });
    var geocoder = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        placeholder: "In OMaps suchen",
        localGeocoder: omapsGeocoder,
        country: 'DE',
        language: 'DE',
        zoom: defaultDetailZoom,
        suggestTimeout: 1000,
        limit: 20,
        minLength: 3,
        filter: omapsGeocoderFilter

    });
    map.addControl(geocoder, "top-left");

    map.addLayer({
        "id": "attribution-layer",
        "type": "circle",
        "source": {
            "type": "geojson",
            "data": {
                "type": "Feature",
                "properties": {},
                "geometry": null
            }
        }
    });
    map.style.sourceCaches['attribution-layer']._source.attribution = " <a href='/admin'><b>Administration</b></a> | &copy; OMaps.de - Kartenverzeichnis Orientierungssport Deutschland | <a href='/impressum'><b>Impressum</b></a>";

    map.addControl(new mapboxgl.NavigationControl({
            showCompass: false
        }
    ), 'bottom-right');

    const addMapControl = new AddMapControl();

    map.addControl(addMapControl, "top-left");


    geocoder.on('result', function(ev) {
        //map.getSource('single-point').setData(ev.result.geometry);
        console.log(ev.result);
        if(ev.result.id.indexOf('omaps')>-1){
            populateMapDetails(ev.result.id.replace('omaps.',''));
        }
    });
});


class AddMapControl {
    onAdd(map) {
        this._map = map;
        this._btn = document.createElement('button');
        this._btn.className = 'mapboxgl-ctrl-icon mapboxgl-ctrl-add';
        this._btn.type = 'button';
        this._btn['aria-label'] = 'Add';
        this._btn.onclick = function () {
            window.location.href = "/admin";
        };
        this._container = document.createElement('div');
        this._container.className = 'mapboxgl-ctrl mapboxgl-ctrl-group';
        this._container.appendChild(this._btn);
        return this._container;
    }
    onRemove() {
        this.container.parentNode.removeChild(this.container);
        this.map = undefined;
    }
}

