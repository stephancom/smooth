module Smooth::Model::Attributes
  extend ActiveSupport::Concern

  included do
  end

  def self.decorate child
    child.attribute :id, Integer
  end

  module ClassMethods
    def attribute name, type, *args
      options = args.extract_options!
      result = super

      attribute_names << name

      result
    end

    def attribute_names
      @attribute_names ||= Set.new
    end
  end
end
