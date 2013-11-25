module Smooth
  class Storage

    def self.manager
      Smooth::Storage::Manager.instance
    end

    InvalidStorageKey = Class.new(Exception)

    class_attribute :store

    attr_accessor :storage,
                  :key,
                  :last_persisted_at

    def initialize(backend, options={})
      @key = options.fetch(:key, backend.try(:id))

      raise InvalidStorageKey unless @key

      Smooth::Storage::Manager.instance.register(self)

      @storage = restore

      @last_persisted_at = Time.now.utc
    end

    def restore
      self.storage = (self.class.store ||= {}).fetch(key,{})
    end

    def timer
      (Time.now.utc - last_persisted_at).to_i
    end

    def persist
      store = self.class.store ||= {}
      store[key] = self.storage
      store[key]
    end
  end
end

require "smooth/storage/manager.rb"
require "smooth/storage/amazon.rb"
require "smooth/storage/disk.rb"
require "smooth/storage/gist.rb"
require "smooth/storage/google_document.rb"
require "smooth/storage/rails_cache.rb"
