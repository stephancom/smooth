module Smooth
  class Model
    module Persistence
      extend ActiveSupport::Concern

      included do

      end

      # This should delegate to the collection sync method
      # which is capable of getting a single record
      def sync method=:read, *args
        raise InvalidCollection unless collection && collection.respond_to?(:sync)

        case

        when is_new?
          unless before_save == false
            self.id = collection.sync(:create, self).id
          end
        when !is_new? && method == :update
          unless before_save == false
            collection.sync(:update, self)
          end
        else
          collection.sync(:read)
        end

        fetch
      end

      def before_save
        true
      end

      def save
        is_new? ? sync(:create) : sync(:update)
      end

      def update_attributes attributes={}
        self.send(:set_attributes, attributes)
        save
      end

      # the collection should implement this single object find
      def fetch
        return self unless self.id

        model = collection.models.detect do |item|
          item[id_field].to_s == self.id.to_s
        end

        if model && model.attributes.is_a?(Hash)
          self.send(:set_attributes, model.attributes)
        end

        self
      end

    end
  end
end
