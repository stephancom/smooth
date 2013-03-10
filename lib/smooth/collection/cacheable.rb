module Smooth
  class Collection
    module Cacheable
      def create_cache_adapter(options)
        case options[:backend]
        when "redis"
          Smooth::Adapters::RedisCache.new(options)
        end
      end
    end
  end
end
