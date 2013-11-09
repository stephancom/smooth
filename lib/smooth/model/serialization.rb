module Smooth::Model::Serialization
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SerializerSupport
  end

  module ClassMethods

  end
end
