require "smooth/queryable/converter"

module Smooth
  module Queryable
    extend ActiveSupport::Concern

    module ClassMethods
      def self.can_be_queried_by *args
        args.extract_options!
      end

      # It is expected that each model class will implement
      # its own query method, which handles all of the various
      # parameters that make sense for that resource
      def query(params={})
        scoped if respond_to?(:scoped)
      end
    end
  end
end
