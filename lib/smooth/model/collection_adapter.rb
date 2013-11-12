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

  def collection= collection
    @collection = collection
  end

  def collection options={}
    @collection || self.class.collection(options)
  end

  module ClassMethods
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
