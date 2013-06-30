module Smooth
  module MetaData
    class Inspector
      attr_accessor :resource

      def initialize(resource)
        @resource = resource
        @resource = resource.to_s.camelize.constantize if resource.is_a?(String) or resource.is_a?(Symbol)
      end

      def presenters
        resource.presenter_class.public_methods - Object.methods
      end

      def queryable_parameters
        resource.queryable_keys
      end

      def queryable_settings
        resource.smooth_queryable_settings.to_hash
      end

      def to_hash
        {
          presentable: {
            formats: presenters
          },
          queryable: {
            parameters: queryable_parameters,
            settings: queryable_settings
          }
        }
      end

      def as_json
        to_hash
      end
    end
  end
end
