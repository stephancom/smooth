module Smooth::ModelDecorators
  mattr_accessor :list

  def self.list
    @@list ||= []
  end

  def self.each &iterator
    @@list.each(&iterator)
  end

  def self.register decorator
    self.list << decorator
  end
end

require 'json'
require 'smooth/model/attributes'
require 'smooth/model/persistence'
require 'smooth/model/serialization'
require 'smooth/model/collection_adapter'

module Smooth


  class Model

    include Smooth::Model::Attributes
    include Smooth::Model::Persistence
    include Smooth::Model::CollectionAdapter
    include Smooth::Model::Serialization

    InvalidRecord = Class.new(Exception)
    InvalidCollection = Class.new(Exception)

    def self.inherited child
      ModelDecorators.each do |decorator|
        decorator.decorate(child) if decorator.respond_to?(:decorate)
      end
    end

    def initialize(attributes={},options={})
      options ||= {}
      attributes ||= {}

      @model_options  = options.dup
      @collection     = options[:collection] && options.delete(:collection)

      raise InvalidRecord unless attributes.is_a?(Hash)

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
