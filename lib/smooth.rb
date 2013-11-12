require "smooth/version"
require "smooth/dependencies"
require "smooth/collection"

require "smooth/model"

module Smooth
  InvalidCollection ||= Class.new(Exception)
  InvalidRecord ||= Class.new(Exception)

  def self.namespace name="App", options={}
    name = name.camelize
    ns = Object.const_get(name) rescue nil
    ns || Smooth::Model::Namespace.create(name,options)
  end
end
