module Smooth
  class Collection
    class Query

      def self.run(collection, options)
        new(collection, options)
      end

      attr_reader :collection,
                  :params

      def initialize collection, params={}
        @collection = collection
        @params     = params
      end

      def results
        @results = run_against(collection.backend)

        return @results unless @results.nil?

        collection.fallbacks.detect do |backend|
          @results = run_against(backend)
        end

        @results
      end

      def cache_key
        params.keys.sort.inject([]) {|memo, key| memo << "#{ key }:#{ params[key] }" }.join("/")
      end

      def to_hash
        params
      end

      protected

        def run_against backend
          backend.query(self)                  
        end

    end
  end
end