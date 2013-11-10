module Smooth
  class Model
    include Virtus

    cattr_accessor :decorators

    self.decorators ||= Set.new

    def self.define model_name, options={}, &block
      namespace = options.fetch(:namespace, Smooth)

      base = options.fetch(:base, Smooth::Model)
      instance_eval %Q{
        class #{ namespace }::#{ model_name.camelize } < #{ base }
          def self.name
            "#{ model_name }"
          end
        end
      }

      model_class = namespace.const_get(model_name.camelize)

      model_class.instance_eval(&block) if block_given?

      model_class
    end

    def self.decorate_with *list
      list.each do |decorator|
        self.send(:include, decorator)

        if decorator.respond_to?(:decorate)
          self.decorators << decorator
        end
      end
    end

    def self.inherited descendant
      super
      decorators.each do |decorator|
        decorator.decorate(descendant)
      end
    end
  end
end
