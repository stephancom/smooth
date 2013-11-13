module Smooth::Model::Serialization
  extend ActiveSupport::Concern

  included do
    class_attribute :serializer_class
  end

  def self.decorate child
    child.configure_serializer
  end

  def active_model_serializer
    self.class.serializer_class
  end

  def read_attribute_for_serialization *args
    send(*args)
  end

  def as_json options={}
    active_model_serializer.new(self).as_json(options)
  end

  def to_hash options={}
    active_model_serializer.new(self).serializable_hash
  end


  module ClassMethods
    def attribute name, klass=String, *args
      super
      serializer_class.attribute(name)
    end

    def active_model_serializer
      serializer_class
    end

    def serializer_class
      @serializer_class || default_serializer
    end

    def serializer_class= value
      self.active_model_serializer= @serializer_class = value
      value
    end

    def serializer_class_name
      (@serializer_class && @serializer_class.to_s) || "#{ self.name }Serializer"
    end

    def default_serializer
      unless serializer_class_name.safe_constantize
        class_eval "class ::#{ serializer_class_name } < ActiveModel::Serializer; end"
      end

      self.serializer_class = serializer_class_name.constantize
    end

    def configure_serializer
      default_serializer if serializer_class.nil?

      attribute_names.each do |name|
        serializer_class.attribute(name)
      end
    end

  end
end
