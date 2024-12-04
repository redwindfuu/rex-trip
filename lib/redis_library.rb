
class RedisLibrary
  def self.get(key)
    data = $redis.get(key)
    return eval(data) if data
    nil
  end

  def self.set(key, value)
    $redis.set key, value.to_s
  end
end
