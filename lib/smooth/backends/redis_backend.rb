class Smooth::RedisBackend < Smooth::MemoryBackend
  include Redis::Objects

  self.redis= Smooth.redis

  counter :id_counter, :start => 1

  def records
    values = redis.hvals(redis_key)

    values.map! do |value|
      value = value.is_a?(String) ? (JSON.parse(value) rescue value) : value
      value.symbolize_keys!
      value
    end

    values
  end

  def all
    records
  end

  def create attributes={}
    obj = super(attributes)
    obj.symbolize_keys!
    redis.hset redis_key, obj[:id], JSON.generate(obj)
    obj
  end

  def destroy id
    id = id.is_a?(Hash) ? id.fetch(:id, id.fetch('id',nil)) : id
    obj = id && show(id)
    obj && redis.hdel(redis_key, id)
    obj
  end

  def show id
    value = redis.hget(redis_key, id)
    value = value && JSON.parse(value)
    value.symbolize_keys! if value.is_a?(Hash)

    value
  end

  def update id, attributes={}
    object = show(id)
    object.symbolize_keys!
    object.merge!(attributes.symbolize_keys)
    redis.hset redis_key, id, JSON.generate(object)
    object
  end

  def redis_key
    id
  end

  protected
    def delete!
      redis.del(redis_key)
    end

    def redis_object_present?
      redis.type(redis_key) == "hash"
    end

    def redis
      self.class.redis
    end

    def assign_id_to object
      object[:id] ||= self.id_counter.increment
      object[:id]
    end

end
