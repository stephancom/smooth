module Smooth::Model::Attributes
  extend ActiveSupport::Concern

  def self.decorate child
    child.attribute :id, Integer
  end

  module ClassMethods
    def attribute *args
      modify_code!
      super
    end

    def attribute_names
      attribute_set.map(&:name)
    end
  end
end
