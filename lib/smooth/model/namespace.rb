class Smooth::Model::Namespace
  attr_accessor :name, :options

  def self.create ns_name, options={}
    namespace = options.delete(:namespace) || Class.new(Smooth::Model::Namespace)
    Object.const_set(ns_name.camelize, namespace)
  end

  def self.define model_name, options={}, &block
    options[:namespace] = namespace
    Smooth::Model.send :define, model_name, options, &block
  end

  def self.namespace
    self
  end

  def self.lookup_model_class_by alias_key
    const_get(alias_key.singularize.camelize)
  end

  protected
    def initialize name, options
      @name = name.to_s.camelize
      @options = options
    end

    def namespace
      name
    end

    def lookup_model_class_by alias_key
      self.class.lookup_model_class_by(alias_key)
    end
end
