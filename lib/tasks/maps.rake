namespace :maps do
  desc "Generate all published maps to GeoJSON file"
  task generate_all_as_geojson: :environment do
    maps = Map.available_maps_as_geojson({search: false})
    File.open("public/maps.json", "w+") do |f|
      f.write(maps.to_json)
    end
  end

  desc "Generate all published maps to GeoJSON file for searchbox"
  task generate_search_as_geojson: :environment do
    maps = Map.available_maps_as_geojson({search: true})
    File.open("public/search.json", "w+") do |f|
      f.write(maps.to_json)
    end
  end

end
