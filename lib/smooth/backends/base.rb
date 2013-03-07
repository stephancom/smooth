module Smooth
  module Backends
    class Base

      # A Naive query method which only matches for equality
      def query params={}
        if params.is_a?(Smooth::Collection::Query)
          params = query.to_hash
        end

        params.symbolize_keys!

        Array(index).select do |record|
          params.keys.all? do |key|
            record[key] == params[key]
          end
        end
      end            
    end
  end
end      