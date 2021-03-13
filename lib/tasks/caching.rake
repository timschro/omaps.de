namespace :caching do
  desc "Rebuilds complete Redis cache"
  task build_cache: :environment do
    Map.published.each do |m|
      MapCacheJob.perform_later m
    end
  end
  
  desc "Rebuilds batch of Redis cache"
  task build_cache_batch: :environment do
    Map.order(:updated_at).limit(100).each do |m|
      m.touch
    end
  end

end
