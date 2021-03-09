redis_url = ENV.fetch("REDIS_URL") { "redis://localhost:6379" }

REDIS = Redis.new(url: redis_url)