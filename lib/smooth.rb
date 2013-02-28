require 'active_support/core_ext'
module Smooth
  DataDirectory = File.join(ENV['HOME'],'.smooth')
  require 'smooth/version'
  require 'smooth/backends/file'
  require 'smooth/backends/redis'
  require 'smooth/collection'  
end