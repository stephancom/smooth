module Smooth
  module MetaData
    class Inspector
      attr_accessor :resource

      def initialize(resource)
        @resource = resource
        @resource = resource.to_s.camelize.constantize if resource.is_a?(String) or resource.is_a?(Symbol)
      end

      def presenters
        methods = [:default]
        methods += resource.presenter_class.public_methods - Object.methods

        methods.uniq
      end

      def queryable_parameters
        resource.queryable_keys
      end

      def queryable_settings
      end

      def resource_is_presentable?
        resource && resource.ancestors.include?(Smooth::Presentable)
      end

      def resource_is_queryable?
        resource && resource.ancestors.include?(Smooth::Queryable)
      end

      def presentable_settings
        return {} unless resource_is_presentable?

        {
          presentable: {
            formats: presenters
          }
        }
      end

      def queryable_settings
        return {} unless resource_is_queryable?

        {
          queryable:{
            parameters: queryable_parameters,
            settings: resource.smooth_queryable_settings.to_hash
          }
        }
      end

      def to_hash
        hash = {}
        hash.merge!(presentable_settings)
        hash.merge!(queryable_settings)

        hash
      end

      def as_json
        to_hash
      end
    end
  end
end
