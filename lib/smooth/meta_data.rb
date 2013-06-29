require "smooth/meta_data/inspector"

module Smooth
  module MetaData
    def self.resource_settings
      @resource_settings ||= {}
    end

    def self.register_resource(resource, options={})
      resource = resource.to_s.camelize.constantize if resource.is_a?(String) or resource.is_a?(Symbol)
      resource_settings[resource.to_s] = Inspector.new(resource)

      resource.to_s
    end

    def self.available_resources
      resource_settings.keys
    end

    def self.[] resource_name
      resource_settings[resource_name]
    end

    module Adapter
      def register_resource_meta_data klass
        Smooth::MetaData.register_resource(klass)
      end
    end
  end
end
