module Smooth
  class Model
    module Serialization
      extend ActiveSupport::Concern

      included do

      end

      def to_json options = {}
        active_model_serializer.new(self).to_json options
      end

      def as_json options={}
        active_model_serializer.new(self).as_json options
      end

    end
  end
end

Smooth::ModelDecorators.register Smooth::Model::Serialization
