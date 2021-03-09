class MapCacheJob < ApplicationJob
  queue_as :default

  def perform(*maps)
    maps.each do |map|
      logger.info("cache map map_#{map.id}")
      images = []
      json =  {
        type: 'Feature',
        geometry: {
            type: 'Point',
            coordinates: [map.lng, map.lat]
        },
        properties: {
            id: map.id,
            name: map.title,
            club: map.club.name,
            year: map.year,
            type: map.map_type.title,
            contours: map.contours,
            description: map.description,
            identifier: map.identifier,
            discipline: map.discipline.nil? ? "" : map.discipline.name,
            map_type: map.map_type.title,
            mapper: map.mapper,
            region: map.region,
            scale: map.scale,
            contact_email: map.contact_email
        }
    } 
    REDIS.set("map_#{map.id}", json.to_json)
    
    
    json =  {
          type: 'Feature',
          geometry: {
              type: 'Point',
              coordinates: [map.lng, map.lat]
            },
          properties: {
              id: map.id,
              name: map.title,
              club: map.club.name,
              year: map.year,
              discipline: map.discipline.nil? ? "" : map.discipline.name,
              type: map.map_type.title
          }
      }
      REDIS.set("map_#{m.id}", json.to_json)
      

      json =  {
          type: 'Feature',
          id: "omaps.#{map.id}",
          text: "#{map.title} (#{map.club.name})",
          center: [map.lng, map.lat]
      }
      REDIS.set("s_#{map.id}", json.to_json)



    end
    
    
    
  end
end
