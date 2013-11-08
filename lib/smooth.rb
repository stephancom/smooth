require 'active_support/core_ext'
require 'active_record'
require 'active_model_serializers'
require 'typhoeus'
require 'redis'
require 'redis-namespace'
require 'squeel'
require 'virtus'

module Smooth
  mattr_accessor :data_directory, :namespace

  def self.namespace
    @@namespace || "smooth"
  end

  def self.project
    if defined?(::Rails)
      Rails.application.class.to_s
    end
  end

  def self.environment
    ENV['RAILS_ENV'] || ENV['SMOOTH_ENV'] || "development"
  end

  def self.data_directory
    @@data_directory || File.join(ENV['HOME'],'.smooth',environment)
  end

  require 'smooth/version'
  require 'smooth/meta_data'
  require 'smooth/meta_data/application'

  require 'smooth/queryable'

  require 'smooth/presentable/chain'
  require 'smooth/presentable/controller'
  require 'smooth/presentable/api_endpoint'
  require 'smooth/presentable'

  require 'smooth/backends/base'
  require 'smooth/backends/active_record'
  require 'smooth/backends/file'
  require 'smooth/backends/redis'
  require 'smooth/backends/redis_namespace'
  require 'smooth/backends/rest_client'

  require 'smooth/adapters/redis_cache.rb'

  require 'smooth/model'
  require 'smooth/collection/cacheable'
  require 'smooth/collection/query'

  require 'smooth/collection'
  require "smooth/resource"
end
