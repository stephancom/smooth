module Smooth::Model::Relationships
  extend ActiveSupport::Concern

  included do

  end

  def relationship_class_for relationship
    @_relation_class_cache ||= {}
    klass = @_relation_class_cache[relationship] ||= self.class.relationship_class_for(relationship).to_s

    klass.constantize
  end

  module ClassMethods
    def relationship_class_for relationship
      relationship = relationship.to_s.singularize.camelize
      namespace.const_get(relationship)
    end

    def belongs_to relationship, *args
      options       = args.extract_options!
      key_column    = options.fetch(:foreign_key, relationship.to_s.downcase.underscore + '_id')

      unless attribute_names.include?(key_column)
        attribute key_column.to_sym, Integer
      end

      define_method(relationship) do
        relationship_class_for(relationship).find self.send(key_column)
      end
    end

    def has_many relationship, *args
      options     = args.extract_options!
      key_column  = options.fetch(:foreign_key, relationship.to_s.downcase.singularize.underscore + '_id')

      define_method(relationship) do
        q = {}
        q[key_column] = self.send(:id)
        relationship_class_for(relationship).query(q)
      end
    end
  end
end
