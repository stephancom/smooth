require "smooth/version"
require "smooth/dependencies"
require "smooth/collection"

require "smooth/model"
require "smooth/model/attributes"
require "smooth/model/collection_adapter"
require "smooth/model/namespace"
require "smooth/model/persistence"
require "smooth/model/relationships"
require "smooth/model/serialization"

module Smooth
  InvalidCollection ||= Class.new(Exception)
  InvalidRecord ||= Class.new(Exception)

  Model.decorate_with Model::CollectionAdapter,
                      Model::Serialization,
                      Model::Attributes,
                      Model::Persistence,
                      Model::Relationships

  def self.namespace name="App", options={}
    name = name.camelize
    ns = Object.const_get(name) rescue nil
    ns || Smooth::Model::Namespace.create(name,options)
  end
end
