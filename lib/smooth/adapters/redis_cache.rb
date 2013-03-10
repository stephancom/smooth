module Smooth
  module Adapters
    class RedisCache
      attr_accessor :redis

      def initialize redis, options={}
        if redis.is_a?(Hash)
          options = redis
          redis = nil
        end

        @redis = redis || Redis.new(options)
      end

      def get key
        redis.get(key)
      end

      def write key, value
        redis.set(key, value)
        value
        end

      def fetch key
        result = get(key) 

        if result.nil? and block_given?
          fallback = yield
          result = write(key, fallback)
        end

        result
      end
    end
  end
end