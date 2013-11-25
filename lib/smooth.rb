require "smooth/version"
require "smooth/dependencies"

module Smooth
  InvalidCollection ||= Class.new(Exception)
  InvalidRecord ||= Class.new(Exception)

  mattr_accessor :data_directory, :environment

  def self.redis= connection
    if !connection.is_a?(Redis::Namespace) && connection.is_a?(Redis)
      connection = Redis::Namespace.new(environment.to_sym, redis: connection)
    end

    @@redis = connection
  end

  def self.redis options={}
    @@redis ||= Redis::Namespace.new(environment.to_sym, :redis => Redis.new(options))
  end

  def self.environment
    ENV['SMOOTH_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || @@environment || "development"
  end

  def self.data_directory
    @@data_directory ||= Pathname.new(File.join(ENV['HOME'],'.smooth',environment))
  end

  def self.namespace name="App", options={}
    name = name.camelize
    ns = Object.const_get(name) rescue nil
    ns || Smooth::Namespace.create(name,options)
  end
end

require "smooth/namespace"
require "smooth/collection"
require "smooth/model"
require "smooth/code_generators"
