module Smooth
  module Backends
    class Base
      def query params={}
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