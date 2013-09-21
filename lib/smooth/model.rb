require 'json'

module Smooth
  class Model
    attr_accessor :attributes, :options, :collection

    InvalidRecord = Class.new(Exception)

    def initialize(attributes={},options={})
      @attributes = attributes.dup.symbolize_keys
      @options = options.dup
      @collection = options[:collection]

      raise InvalidRecord unless attributes.is_a?(Hash)
    end

    def get(key)
      @attributes[key.to_sym]
    end

    def set(key, value=nil, options=nil)
      case
        when value.present? && key.respond_to?(:to_sym)
          @attributes[key.to_sym] = value
        when value.nil? && key.is_a?(Hash)
          @attributes = key
      end

      self
    end

    # This should delegate to the collection sync method
    # which is capable of getting a single record
    def sync method=nil, model=nil, options={}
      model ||= self
      method ||= :read
      method = :create if is_new?

      collection && collection.sync(method, model, options)
    end

    # the collection should implement this single object find
    def fetch
      return self unless self.id

      model_attributes = sync(:read,self).detect do |item|
        item[id_field] == self.id
      end

      if model_attributes.is_a?(Hash)
        self.set(model_attributes)
      end

      self
    end

    def is_new?
      id.nil?
    end

    def id
      @id ||= @attributes[id_field]
    end

    def as_json
      @attributes
    end

    def to_json
      JSON.stringify(as_json)
    end

    protected

      def id_field
        options[:id_field] || :id
      end
  end
end
