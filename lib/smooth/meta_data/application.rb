module Smooth
  module MetaData
    class Application
      attr_accessor :app, :options, :data

      def initialize(app, options={})
        @app = app
        @options = options
      end

      def call(env)
        [200,{},[""]]
      end
    end
  end
end
