namespace :caching do
  desc "Rebuilds complete Redis cache"
  task build_cache: :environment do
    Map.all.each do |m|
      MapCacheJob.perform_later m
    end
  end

end
