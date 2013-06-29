require "smooth/queryable/converter"
require "smooth/queryable/settings"

module Smooth
  module Queryable
    extend ActiveSupport::Concern

    included do
      extend Smooth::MetaData::Adapter
      class_attribute :smooth_queryable_settings
      register_resource_meta_data(self)
    end

    module ClassMethods
      def can_be_queried_by parameter, *args
        options = args.extract_options!

        settings = self.smooth_queryable_settings ||= Settings.new()

        settings.apply_query_options(parameter, options)
      end

      # It is expected that each model class will implement
      # its own query method, which handles all of the various
      # parameters that make sense for that resource
      def query(params={})
        scoped if respond_to?(:scoped)
      end

      def queryable_keys
        smooth_queryable_settings.available_query_parameters
      end
    end
  end
end
