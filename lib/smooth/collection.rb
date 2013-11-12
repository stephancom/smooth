require "smooth/backends/backend"
require "smooth/backends/active_record_backend"
require "smooth/backends/memory_backend"
require "smooth/backends/file_backend"
require "smooth/backends/redis_backend"
require "smooth/backends/rest_backend"

module Smooth
  class Collection
    include ActiveModel::ArraySerializerSupport

    class_attribute :model_class, :backend_class, :backend

    def self.model_class
      @model_class ||= self.name.gsub('::Collection','').constantize
    end

    def self.backend_class
      @backend_class || Smooth::MemoryBackend
    end

    def self.backend options={}
      @backend ||= backend_class.new(options)
    end

    attr_accessor :options, :models, :id_sequence

    def initialize model_class=nil, *args
      @model_class  = model_class
      @options      = args.extract_options! || {}
      @namespace    = options.delete(:namespace)
      @id_sequence  = options.delete(:id_sequence) || 0
      @models       = Array options.delete(:models)
    end

    def model_class
      @model_class || self.class.model_class
    end

    def backend_class
      options[:backend_class] || self.class.backend_class
    end

    def namespace
      @namespace
    end

    def create attributes={}
      backend.create(attributes)
    end

    def update model_id, attributes={}
      backend.update(model_id, attributes)
    end

    def destroy model_id
      backend.destroy(model_id)
    end

    def each &iterator
      models.each(&iterator)
    end

    def sync action, model_or_attributes={}, options={}
    end
  end
end
