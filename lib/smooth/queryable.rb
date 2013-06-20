module Smooth
  module Queryable
    extend ActiveSupport::Concern

    module ClassMethods
      # It is expected that each model class will implement
      # its own query method, which handles all of the various
      # parameters that make sense for that resource
      def query(params={})
        scoped
      end
    end
  end
end
