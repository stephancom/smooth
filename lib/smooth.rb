require 'active_support/core_ext'
require 'active_record'
require 'typhoeus'
require 'redis'
require 'squeel'
require 'virtus'

module Smooth
  DataDirectory = File.join(ENV['HOME'],'.smooth')

  require 'smooth/version'
  require 'smooth/backends/base'
  require 'smooth/backends/active_record'
  require 'smooth/backends/file'
  require 'smooth/backends/redis'
  require 'smooth/backends/rest_client'

  require 'smooth/adapters/redis_cache.rb'
  
  require 'smooth/collection/cacheable'  
  require 'smooth/collection/query'
  require 'smooth/collection'
end