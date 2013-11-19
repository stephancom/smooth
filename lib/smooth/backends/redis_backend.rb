class Redis::HashKey
  # Gets the value of a field
  def [](field)
    hget(field)
  end

  # Redis: HGET
  def hget(field)
    from_redis redis.hget(key, field), options[:marshal_keys][field]
  end

  def fetch field, *args, &block
    value = hget(field)
    default = args[0]

    return value if value || (!default && !block_given?)

    block_given? ? block.call(field) : default
  end
end

class Smooth::RedisBackend < Smooth::MemoryBackend
  include Redis::Objects

  counter :id_counter, :start => 1
  hash_key :record_storage

  def records
    record_storage
  end

  protected
    def process_records!
      super
      self.record_storage.fill(@records || {})
    end

    def assign_id_to object
      object[:id] ||= self.id_counter.increment
      object[:id]
    end

end
