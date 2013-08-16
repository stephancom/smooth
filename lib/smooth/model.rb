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

    def set(key, value, options=nil)
      @attributes[key.to_sym] = value
      self
    end

    def sync method=nil, model=nil, options={}
      model ||= self
      method ||= :read
      method = :create if is_new?

      collection && collection.sync(method, model, options)
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
