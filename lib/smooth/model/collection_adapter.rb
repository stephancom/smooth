module Smooth::Model::CollectionAdapter
  extend ActiveSupport::Concern

  included do
    class_attribute :collection_class
  end

  def self.decorate child
    child.configure_collection if child.collection_class.nil?
  end

  def collection_class
    self.class.collection_class
  end

  def backend_class
    self.class.backend_class
  end

  def collection= collection
    @collection = collection
  end

  def collection options={}
    @collection || self.class.collection(options)
  end

  def active_record_backend?
    self.class.active_record_backend?
  end

  module ClassMethods

    def backend_class
      collection_class.backend_class
    end

    def active_record_backend?
      backend_class == Smooth::ActiveRecordBackend || (backend_class < Smooth::ActiveRecordBackend)
    end

    def use backend, *args
      options = args.extract_options!
      name = backend.to_s.camelize

      klass = Smooth.const_get("#{ name }Backend") rescue nil
      klass ||= Object.const_get(name) rescue nil
      klass ||= namespace.const_get(name) rescue nil
      klass ||= Smooth.const_get(name) rescue nil

      collection_class.backend_class = if klass < Smooth::Backend
        klass
      elsif klass < ActiveRecord::Base
        Smooth::ActiveRecordBackend
      else
        raise "Invalid Backend specified."
      end

      if options[:attributes] && active_record_backend?
        load_attributes_from_active_record!
      end

    end

    def collection options={}
      @collection ||= collection_class.new(self, options)
    end

    def configure_collection
      instance_eval("#{ collection_class_name } = Class.new(Smooth::Collection)")
      self.collection_class = "#{collection_class_name}".constantize
    end

    def collection_class_name
      (@collection_class && @collection_class.name) || "#{self.name}::Collection"
    end

    def collection_class
      @collection_class || collection_class_name.safe_constantize
    end
  end
end
