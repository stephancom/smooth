module Smooth
  module Backends
    class ActiveRecord < Base

      attr_accessor :model

      def initialize options={}
        @model = options[:model]
        model.send(:include, Smooth::Backends::ActiveRecord::QueryAdapter)
      end      

      def query params={}
        model.smooth_query(params)
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