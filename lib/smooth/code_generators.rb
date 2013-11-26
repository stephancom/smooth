# This is just an experiment w/ different syntactic sugar.
module Smooth
  module CodeGenerators
    require "smooth/code_generators/base"
    require "smooth/code_generators/ember_model"

    class Adapter
      attr_accessor :generator_klass, :source, :output_path

      def initialize(klass, source=nil)
        @generator_klass = klass
        @source = source

        run! if @source
      end

      def run!
        render_assets

        if output_path && File.exists?(output_path)
          File.open(output_path,'w+') do |fh|
            fh.puts @rendered.join("\n###\n")
          end
        end
      end

      def source= source
        @source = source
        run!
        source
      end

      def to_s
        rendered
      end

      def rendered
        Array(@rendered).join "\n"
      end

      def render_assets
        @rendered = assets.flatten.uniq.compact.map(&:render)
      end

      def assets
        [] + model_assets
      end

      def model_assets
        Array(case
          when source.nil?
            raise "Must specify a source model or namespace"
          when source.ancestors.include?(Smooth::Namespace)
            source.models.map do |model_class|
              generator_klass.new(model_class)
            end
          when source.ancestors.include?(Smooth::Model)
            generator_klass.new(source)
        end)
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
