class Smooth::Model
  include Virtus
  include ActiveModel::Validations

  cattr_accessor :decorators

  class_attribute :code_modified_at

  self.code_modified_at = Time.now.utc
  self.decorators ||= Set.new

  def self.modify_code!
    self.code_modified_at = Time.now.utc
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

require "smooth/model/attributes"
require "smooth/model/collection_adapter"
require "smooth/model/persistence"
require "smooth/model/relationships"
require "smooth/model/query_adapter"
require "smooth/model/serialization"

module Smooth
  class Model
    decorate_with Model::CollectionAdapter,
                  Model::Persistence,
                  Model::Serialization,
                  Model::Attributes,
                  Model::Relationships,
                  Model::QueryAdapter

    # The namespace a model's class belongs to. E.g
    # Application::Model.namespace == Application
    def namespace
      self.class.namespaace
    end

    # The namespace a model class belongs to. E.g
    # Application::Model.namespace == Application
    def self.namespace
      parts = to_s.split('::')
      parts.pop
      parts.length > 0 ? parts.join('').constantize : Object
    end

    # def
    def self.define model_name, options={}, &block
      ns = options.fetch(:namespace, namespace)

      base = options.fetch(:base, Smooth::Model)

      ns = ns.class unless ns.is_a?(Class)

      code = %Q{
        class #{ ns }::#{ model_name.camelize } < #{ base }
          def self.name
            "#{ model_name }"
          end
        end
      }

      instance_eval(code)

      model_class = ns.const_get(model_name.camelize)

      model_class.instance_eval(&block) if block_given?

      model_class
    end

    def self.find_active_record_for model_class
      name = model_class.to_s.split('::').last
      Object.const_get(name) rescue nil
    end
  end
end
