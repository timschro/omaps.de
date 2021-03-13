class MapUncacheJob < ApplicationJob
  queue_as :default

  def perform(*maps)
    maps.each do |map|
      logger.info("uncache map map_#{map.id}")
      REDIS.del("map_#{map.id}")
      REDIS.del("m_#{map.id}")
      REDIS.del("s_#{map.id}")
    end
    
  end
end
