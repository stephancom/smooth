module Smooth
  module CodeGenerators
    require "smooth/code_generators/base"
    require "smooth/code_generators/ember_model"

    class Adapter
      attr_accessor :generator

      def initialize generator
        @generator = generator
      end

      def run
        self
      end

      def [] namespace
        on(namespace)
      end

      def on namespace
        namespace.models.map do |k|
          generator.new(k).render.strip
        end.join("\n")
      end
    end

    def self.for generator
      send(:[],generator)
    end

    def self.[] generator
      case generator
      when :ember
        Adapter.new(EmberModel)
      end
    end
  end
end
