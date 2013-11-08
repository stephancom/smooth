require 'virtus'
require 'active_model_serializers'

module Smooth
  class Model
    module Attributes
      extend ActiveSupport::Concern

      included do
       include Virtus unless ancestors.include?(Virtus)
      end

      def self.decorate child
        child.attribute(:id, Integer)
      end

    end
  end
end

Smooth::ModelDecorators.register Smooth::Model::Attributes
