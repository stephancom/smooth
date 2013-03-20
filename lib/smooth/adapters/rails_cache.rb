module Smooth
  module Adapters
    class RailsCache

      def get key
        Rails.cache.get(key)
      end

      def write key, value
        Rails.cache.write(key, value)
        value
      end

      def fetch key, &block
        Rails.cache.fetch key, &block
      end
    end
  end
end