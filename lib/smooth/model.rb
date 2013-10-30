require 'json'

module Smooth
  class Model
    include Virtus

    attr_accessor :model_attributes, :collection, :model_options

    InvalidRecord = Class.new(Exception)
    InvalidCollection = Class.new(Exception)

    def initialize(attributes={},options={})
      options ||= {}
      attributes ||= {}

      @model_options  = options.dup
      @collection     = options[:collection] if options[:collection]

      raise InvalidRecord unless attributes.is_a?(Hash)

      unless respond_to?(:id)
        extend(Virtus)
        self.class.attribute :id, String unless respond_to?(:id)
      end

      super(attributes)
    end

    # This should delegate to the collection sync method
    # which is capable of getting a single record
    def sync method=:read, *args
      raise InvalidCollection unless collection && collection.respond_to?(:sync)

      case

      when is_new?
        unless before_save == false
          self.id = collection.sync(:create, self).id
        end
      when !is_new? && method == :update
        unless before_save == false
          collection.sync(:update, self)
        end
      else
        collection.sync(:read)
      end

      fetch
    end

    def before_save
      true
    end

    def save
      is_new? ? sync(:create) : sync(:update)
    end

    def update_attributes attributes={}
      self.send(:set_attributes, attributes)
      save
    end

    # the collection should implement this single object find
    def fetch
      return self unless self.id

      model = collection.models.detect do |item|
        item[id_field].to_s == self.id.to_s
      end

      if model && model.attributes.is_a?(Hash)
        self.send(:set_attributes, model.attributes)
      end

      self
    end

    def is_new?
      id.nil?
    end

    def id
      attributes.fetch(:id, nil)
    end

    def as_json options={}
      base = to_hash rescue @attributes

      base = Array(options[:methods]).inject(base || {}) do |memo,meth|
        memo[meth] = send(meth) if meth && respond_to?(meth)
        memo
      end

      base
    end

    def to_json options={}
      JSON.generate(as_json(options))
    end

    protected

      def id_field
        model_options.fetch(:id_field, :id)
      end
  end
end
