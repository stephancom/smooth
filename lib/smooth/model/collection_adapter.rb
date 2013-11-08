module Smooth
  class Model
    module CollectionAdapter
      extend ActiveSupport::Concern

      included do
        class_attribute :default_backend
      end

      def self.decorate child
        child.const_set("Collection", Class.new(Smooth::Collection))
        child.collection_class
      end

      def collection
        @collection ||= collection_class.new(backend: backend)
      end

      def default_backend
        self.class.default_backend
      end

      def collection_class
        self.class.collection_class
      end

      module ClassMethods
        def uses_backend backend
          self.backend = backend
        end

        def backend
          @backend
        end

        def collection_class
          const_get('Collection')
        end
      end
    end
  end
end

Smooth::ModelDecorators.register(Smooth::Model::CollectionAdapter)
