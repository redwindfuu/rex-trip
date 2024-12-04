# config/initializers/redis.rb
host = ENV.fetch("REDIS_HOST") { "localhost" }
port = ENV.fetch("REDIS_PORT") { 6379 }
password = ENV.fetch("REDIS_PASSWORD") { nil }

$redis = Redis.new(host: host, port: port, password: password)
