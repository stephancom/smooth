require "smooth/model/attributes"
require "smooth/model/collection_adapter"
require "smooth/model/serialization"

module Smooth
  class Model
    include Smooth::Model::Attributes
    include Smooth::Model::CollectionAdapter
    include Smooth::Model::Serialization
  end
end
