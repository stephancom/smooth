class Smooth::Model::Namespace
  attr_accessor :name, :options

  def self.create ns_name, options={}
    namespace = options.delete(:namespace) || Class.new(Smooth::Model::Namespace)

    Object.const_set(ns_name.camelize, namespace)
  end

  def self.define model_name, options={}, &block
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

  def self.namespace
    self
  end

  protected
    def initialize name, options
      @name = name
      @options = options
    end

    def namespace
      name
    end
end
