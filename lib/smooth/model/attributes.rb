module Smooth::Model::Attributes
  extend ActiveSupport::Concern

  included do
    class_attribute :defined_attributes
    self.defined_attributes = Set.new
  end

  def self.decorate child
    child.attribute :id, Integer
    child.send :class_attribute, :defined_attributes
    child.defined_attributes = Set.new
  end

  module ClassMethods
    def attribute name, type=String, *args
      result = super(name,type,*args)
      options = args.extract_options!

      modify_code!

      unless options[:auto]
        self.defined_attributes << OpenStruct.new({name: name, type: type})
      end

      result
    end

    def attribute! name, type, *args
      args << {auto: true}
      attribute(name,type,*args)
    end

    def attribute_names
      attribute_set.map(&:name)
    end
  end
end
