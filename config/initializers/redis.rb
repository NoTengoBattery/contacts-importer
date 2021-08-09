Resque.redis = Redis.new(url: ENV["REDIS_DATABASE_URL"]) if Rails.env.production?
