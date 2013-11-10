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

  protected
    def initialize name, options
      @name = name
      @options = options
    end

    def namespace
      name
    end
end
