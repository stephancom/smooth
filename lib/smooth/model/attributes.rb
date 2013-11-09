module Smooth::Model::Attributes
  extend ActiveSupport::Concern

  included do
    include Virtus
    alias_method :original_attribute, :attribute
  end

  module ClassMethods
    def attribute name, klass, options={}
      original_attribute name, klass, options
    end
  end
end
