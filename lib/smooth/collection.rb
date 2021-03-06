require "smooth/backend"

module Smooth
  class Collection
    include ActiveModel::ArraySerializerSupport

    class_attribute :model_class, :backend_class, :backend

    def self.model_class
      @model_class ||= self.name.gsub('::Collection','').constantize
    end

    def self.model_namespace
      model_class.namespace
    end

    def self.namespace
      self.model_class
    end

    def self.backend_class
      @backend_class || (model_class.try(:const_get,'Backend') rescue nil) || (const_get('Backend') rescue nil) || model_namespace.default_backend_class || Smooth::MemoryBackend
    end

    attr_accessor :options, :models, :id_sequence, :backend

    def initialize model_class=nil, *args
      @model_class  = model_class
      @options      = args.extract_options! || {}
      @namespace    = options.delete(:namespace)
      @id_sequence  = options.delete(:id_sequence) || 0
      @models       = options.delete(:models)
    end

    def uuid
      nil
    end

    def backend
      @backend ||= self.class.backend_class.new(model_class: model_class,
                                                collection_class: self.class,
                                                namespace: self.class.model_namespace,
                                                uuid: uuid
                                               )
    end

    def model_class
      @model_class || self.class.model_class
    end

    def backend_class
      options[:backend_class] || self.class.backend_class
    end

    def namespace
      @namespace || self.class.namespace
    end

    def all
      models
    end

    def models
      @models ||= backend.all.map {|h| data_or_model(h) }
    end

    def create attributes={}
      data_or_model backend.create(attributes)
    end

    def update model_id, attributes={}
      data_or_model backend.update(model_id, attributes)
    end

    def destroy model_id
      data_or_model backend.destroy(model_id)
    end

    def find model_id
      data_or_model backend.show(model_id)
    end

    def reset list=nil
      @models = Array(list).map {|h| data_or_model(h) }
    end

    def fetch
      @models = nil
      models
    end

    def sync action, model_or_attributes={}, options={}
    end

    def data_or_model hash={}
      hash.is_a?(Hash) ? model_class.new(hash) : hash
    end

    def method_missing meth, *args, &blk
      if %w{each map select reject inject detect collect}.include? meth.to_s
        if all && all.respond_to?(meth)
          all.send(meth,*args,&blk)
        end
      end

      super
    end

  end
end
