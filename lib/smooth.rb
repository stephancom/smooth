require 'active_support/core_ext'
require 'active_record'
require 'typhoeus'
require 'redis'
require 'squeel'
require 'virtus'

module Smooth
  DataDirectory = File.join(ENV['HOME'],'.smooth')

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
  require 'smooth/backends/rest_client'

  require 'smooth/adapters/redis_cache.rb'

  require 'smooth/model'
  require 'smooth/collection/cacheable'
  require 'smooth/collection/query'
  require 'smooth/collection'

  require "smooth/resource"
end
