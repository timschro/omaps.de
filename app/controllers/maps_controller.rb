class MapsController < ApplicationController

  caches_page :index, :search


  def index
    maps = Map.published_and_approved
    geojson = {
        type: 'FeatureCollection',
        features: []
    }

    maps.each do |m|
      geojson[:features] << {
          type: 'Feature',
          geometry: {
              type: 'Point',
              coordinates: [m.lng, m.lat]
          },
          properties: {
              id: m.id,
              name: m.title,
              club: m.club.name,
              year: m.year,
              type: m.map_type.title
          }
      }
    end

    respond_to do |format|
      format.json { render json: geojson }
    end
  end


  def search
    maps = Map.published_and_approved
    geojson = {
        type: 'FeatureCollection',
        features: []
    }

    maps.each do |m|
      geojson[:features] << {
          type: 'Feature',
          id:  "omaps.#{m.id}",
          text: m.title,
          center: [m.lng, m.lat]
      }


    end
    respond_to do |format|
      format.json { render json: geojson }
    end
  end




  def show

    @map = Map.published_and_approved.where(id: params[:id]).last

    geojson = {
      type: 'Feature',
      geometry: {
          type: 'Point',
          coordinates: [@map.lng, @map.lat]
      },
      properties: {
          id: @map.id,
          name: @map.title,
          club: @map.club.name,
          year: @map.year,
          type: @map.map_type.title,
          contours: @map.contours,
          description: @map.description,
          url: map_detail_url(@map.url),
          identifier: @map.identifier,
          map_type: @map.map_type.title,
          mapper: @map.mapper,
          region: @map.region,
          scale: @map.scale,
          contact_email: @map.contact_email
      }
    }


    respond_to do |format|
      format.json { render json: geojson}
    end

  end
end
