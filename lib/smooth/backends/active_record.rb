module Smooth
  module Backends
    class ActiveRecord < Base

      attr_accessor :model

      def initialize options={}
        super
        @model = options[:model]
        model.send(:include, Smooth::Backends::ActiveRecord::QueryAdapter)
      end      

      def query params={}
        model.respond_to?(:query) ? model.query(params) : model.smooth_query(params)
      end

      def index
        model.scoped
      end

      def show id
        model.find(id)
      end

      def update attributes
        record = model.find(attributes[:id])        
        record.update_attributes(attributes)
        record
      end

      def destroy id
        !!(model = model.find(id) && model.destroy)
      end

      def create attributes
        record = model.create(attributes)
      end
    end

    module ActiveRecord::QueryAdapter

      module ClassMethods
        def smooth_query params={}
          scoped           
        end
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
      end

    end

  end
end