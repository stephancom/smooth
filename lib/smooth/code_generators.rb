# This is just an experiment w/ different syntactic sugar.
module Smooth
  module CodeGenerators
    require "smooth/code_generators/base"
    require "smooth/code_generators/ember_model"

    class Adapter
      attr_accessor :generator_klass, :source, :output_path

      def initialize(klass)
        @generator_klass = klass
      end

      def run!
        case
          when source.nil?
            raise "Must specify a source model or namespace"
          when source.ancestors.include?(Smooth::Namespace)
            puts "Boom! Namespace"
          when source.ancestors.include?(Smooth::Model)
            puts "Boom! Model"
        end
      end
    end

    def self.for generator
      case generator.to_sym
      when :ember
        Adapter.new(EmberModel)
      end
    end
  end
end
