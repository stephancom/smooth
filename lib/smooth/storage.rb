module Smooth
  class Storage
    class_attribute :store

    attr_accessor :storage, :key

    def initialize(options={})
      @key = options[:key]
      @storage = restore
    end

    def restore
      self.storage = (self.class.store ||= {}).fetch(key,{})
    end

    def persist
      store = self.class.store ||= {}
      store[key] = self.storage
      store[key]
    end
  end
end

require "smooth/storage/amazon.rb"
require "smooth/storage/disk.rb"
require "smooth/storage/gist.rb"
require "smooth/storage/google_document.rb"
require "smooth/storage/rails_cache.rb"
