module Smooth::Model::Attributes
  extend ActiveSupport::Concern

  def self.decorate child
    child.attribute :id, Integer
  end

  module ClassMethods
    def attribute name, type=String, *args
      modify_code!
      super(name,type,*args)
    end

    def attribute_names
      attribute_set.map(&:name)
    end
  end
end
