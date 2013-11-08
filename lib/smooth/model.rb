require 'json'
require 'smooth/model/persistence'

module Smooth
  class Model

    include ActiveModel::SerializerSupport
    include Virtus

    include Smooth::Model::Persistence

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
        self.class.attribute :id, Integer unless respond_to?(:id)
      end

      super(attributes)
    end

    def is_new?
      id.nil?
    end

    def model_options
      @model_options
    end

    def collection
      @collection
    end

    def collection= collection
      @collection = collection
    end

    protected

      def id_field
        model_options.fetch(:id_field, :id)
      end
  end
end
