module Smooth
  module Backends
    class RedisNamespace < Smooth::Backends::Redis
      def initialize options={}
        @namespace, @priority = options.values_at(:namespace, :priority)
        @connection           = ::Redis::Namespace.new( @namespace, redis: ::Redis.new(options.fetch(:redis_options, {})))
      end
    end
  end
end
