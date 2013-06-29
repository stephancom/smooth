module Smooth
  module Queryable
    class Settings
      attr_accessor :query_parameters

      def initialize(options={})
        @query_parameters = {}
      end

      def apply_query_options parameter, options={}
        self.query_parameters[parameter] ||= options
      end

      def to_hash
        self.query_parameters
      end

      def available_query_parameters
        self.query_parameters.keys
      end
    end
  end
end
