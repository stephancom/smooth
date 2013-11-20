require "smooth/version"
require "smooth/dependencies"
require "smooth/collection"

require "smooth/model"

module Smooth
  InvalidCollection ||= Class.new(Exception)
  InvalidRecord ||= Class.new(Exception)

  mattr_accessor :data_directory

  def self.data_directory
    @@data_directory ||= Pathname.new(File.join(ENV['HOME'],'.smooth'))
  end

  def self.namespace name="App", options={}
    name = name.camelize
    ns = Object.const_get(name) rescue nil
    ns || Smooth::Model::Namespace.create(name,options)
  end
end
