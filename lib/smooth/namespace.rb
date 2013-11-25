class Smooth::Namespace
  attr_accessor :name, :options

  def self.create ns_name, options={}
    namespace = options.delete(:namespace) || Class.new(Smooth::Namespace)
    Object.const_set(ns_name.camelize, namespace)

    if options[:backend]
      namespace.use(options[:backend])
    end

    namespace
  end

  def self.define model_name, options={}, &block
    options[:namespace] = namespace
    Smooth::Model.send :define, model_name, options, &block
  end

  def self.namespace
    self
  end

  def self.lookup_model_class_by alias_key
    const_get(alias_key.to_s.singularize.camelize)
  end

  def self.models
    constants.map {|k| lookup_model_class_by(k) }.select {|c| c.ancestors.include?(Smooth::Model) }
  end

  def self.code_modified_at
    models.map(&:code_modified_at).sort.reverse.last
  end

  def self.use backend_id
    @default_backend_class = "Smooth::#{ backend_id.to_s.camelize }Backend".constantize
  end

  def self.default_backend_class
    @default_backend_class
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
