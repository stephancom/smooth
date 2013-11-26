module Smooth::Model::Relationships
  extend ActiveSupport::Concern

  def relationship_class_for relationship
    @_relation_class_cache ||= {}
    klass = @_relation_class_cache[relationship] ||= self.class.relationship_class_for(relationship).to_s

    klass.constantize
  end

  def self.decorate child
    child.send :class_attribute, :relationships
    child.relationships = Set.new
  end

  module ClassMethods
    def belongs_to_relationships
      relationships.select do |rel|
        rel.type == "belongs_to"
      end
    end

    def has_many_relationships
      relationships.select do |rel|
        rel.type == "has_many"
      end
    end

    def relationship_class_for relationship
      relationship = relationship.to_s.singularize.camelize
      namespace.const_get(relationship)
    end

    def belongs_to relationship, *args
      options       = args.extract_options!
      key_column    = options.fetch(:foreign_key, relationship.to_s.downcase.underscore + '_id')

      self.relationships << OpenStruct.new(_method: relationship.to_s.camelize(:lower), type: "belongs_to", name: relationship.to_s.camelize, key: key_column)

      modify_code!

      unless attribute_names.include?(key_column)
        attribute! key_column.to_sym, Integer
      end

      define_method(relationship) do
        relationship_class_for(relationship).find self.send(key_column)
      end
    end

    def has_many relationship, *args
      options     = args.extract_options!
      key_column  = options.fetch(:foreign_key, relationship.to_s.downcase.singularize.underscore + '_id')

      self.relationships << OpenStruct.new(type: "has_many", _method: relationship.to_s.camelize(:lower), name: relationship.to_s.singularize.camelize, key: key_column)

      modify_code!

      define_method(relationship) do
        q = {}
        q[key_column] = self.send(:id)
        relationship_class_for(relationship).query(q)
      end
    end
  end
end
