module Smooth::Model::QueryAdapter
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    def query params={}
      models
    end
  end
end
