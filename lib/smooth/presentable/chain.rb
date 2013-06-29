module Smooth
  module Presentable
    # The Chain allows for constructing an API call with the following:
    #
    # Resource.present(query)
    #   .as(format)
    #   .to(user)
    #
    class Chain
      attr_accessor :scope, :format, :recipient

      def initialize(scope)
        @scope      = scope
        @format     = :default
        @recipient  = :default
      end

      def as(format=:default)
        @format = format
        self
      end

      def to(recipient=:default)
        @recipient = recipient
        self
      end

      def results
        @results ||= scope.map do |record|
          record.present_as(format)
        end
      end

      def to_a
        results
      end

      def method_missing meth, *args, &block
        results.send(meth, *args, &block)
      end

    end
  end
end
