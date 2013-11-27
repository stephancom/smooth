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
    def load_attributes_from_active_record!
      if klass = find_active_record_for(self)
        klass.columns.each do |col|
          attribute col.name.to_sym, col.type.to_s.camelize.classify
        end
      end
    end

    def attribute name, type=String, *args
      result = super(name,type,*args)
      options = args.extract_options!

      modify_code!

      # columns that get defined automatically to support
      # relationships, should not be recorded as being explicitly
      # defined
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
