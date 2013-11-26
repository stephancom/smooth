module Smooth
  module CodeGenerators
    class Base
      attr_accessor :klass, :template_file, :options, :path

      def self.generate model_class, options={}
        new(model_class, options)
      end

      def initialize(klass,options={})
        @klass = klass
        @options = options
      end

      def render
        template.result(binding)
      end

      protected :initialize

      def template
        @template ||= ERB.new(IO.read(template_file))
      end

      def template_file
        @template_file || File.join(File.dirname(__FILE__), 'templates', self.class.to_s.split('::').pop.underscore.parameterize + '.erb')
      end

      def cache_key
        parts = [self.class, klass, klass.code_modified_at.to_i]
        parts.map!(&:to_s)
        parts.map!(&:parameterize)

        parts.join ':'
      end
    end
  end
end
