class Smooth::Namespace
  include Singleton

  def self.respond_to?(meth,*args)
    !!(instance.respond_to?(meth) || super)
  end

  def self.method_missing meth,*args,&blk
    instance.send(meth,*args,&blk)
  end

  def self.create name, options={}, &blk
    Object.const_set(name.camelize, Class.new(Smooth::Namespace))
    ns = Object.const_get(name.camelize)

    Smooth.register_namespace(ns)

    ns.use(options[:backend]) if options[:backend]

    if block_given?
      ns.instance_eval(&blk)
    end

    ns
  end

  attr_accessor :default_backend_class, :name

  def define model_name, options={}, &block
    options[:namespace] = self
    model_class = Smooth::Model.send(:define, model_name, options, &block)
    model_class
  end

  def models
    self.class.constants.select {|c| c.is_a?(Smooth::Model)  }
  end

  def lookup_model_class_by aliased
    aliased = aliased.to_s.singularize.camelize
    self.class.const_get(aliased.camelize) rescue nil
  end

  def use backend_id
    klass = "Smooth::#{ backend_id.to_s.camelize }Backend".constantize rescue nil
    self.default_backend_class = klass
    self
  end
end
