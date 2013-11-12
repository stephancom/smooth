module Smooth::Model::Attributes
  extend ActiveSupport::Concern

  included do
  end

  def self.decorate child
    child.attribute :id, Integer
  end

  module ClassMethods
    def attribute *args
      super
    end

    def attribute_names
      attribute_set.map(&:name)
    end
  end
end
