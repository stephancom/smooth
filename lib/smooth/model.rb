require 'json'

module Smooth
  class Model

    include Virtus

    attr_accessor :model_attributes, :collection, :model_options

    InvalidRecord = Class.new(Exception)
    InvalidCollection = Class.new(Exception)

    def initialize(attributes={},options={})
      @model_options  = options.dup
      @collection     = options[:collection] if options[:collection]

      raise InvalidRecord unless attributes.is_a?(Hash)

      extend(Virtus)
      attribute :id, String

      super(attributes)
    end

    # This should delegate to the collection sync method
    # which is capable of getting a single record
    def sync method=nil, model=nil, options={}
      model ||= self
      method ||= :read
      method = :create if is_new?

      raise InvalidCollection unless collection.respond_to?(:sync)

      collection.sync(method, model, options)
    end

    # the collection should implement this single object find
    def fetch
      return self unless self.id

      model_attributes = sync(:read,self).detect do |item|
        item[id_field].to_s == self.id.to_s
      end

      if model_attributes.is_a?(Hash)
        self.send(:set_attributes, model_attributes)
      end

      self
    end

    def is_new?
      id.nil?
    end

    def id
      attributes.fetch(:id, nil)
    end

    def as_json
      to_hash rescue @attributes
    end

    def to_json
      JSON.generate(as_json)
    end

    protected

      def id_field
        model_options.fetch(:id_field, :id)
      end
  end
end
