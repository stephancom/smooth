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

    def self.resources
      resource_settings.inject({}) do |memo,pair|
        resource_name, inspector = pair
        memo[resource_name] = inspector.as_json
        memo
      end
    end

    def self.available_resources
      resource_settings.keys
    end

    def self.[] resource_name
      resource_settings[resource_name]
    end

  end
end
