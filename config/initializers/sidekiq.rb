
localhost = ENV["REDIS_SERVER"] || "localhost"
port = ENV["REDIS_PORT"] || 6379
password = ENV["REDIS_PASSWORD"] || nil

Sidekiq.configure_server do |config|
  config.redis = { 
    url: "redis://#{localhost}:#{port}/1",
    password: password
   }
end

Sidekiq.configure_client do |config|
  config.redis = { 
    url: "redis://#{localhost}:#{port}/1",
    password: password
   }
end


