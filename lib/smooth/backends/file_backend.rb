require "smooth/storage"

class Smooth::FileBackend < Smooth::MemoryBackend
  class_attribute :storage_class

  def self.storage_class
    @storage_class || Smooth::Storage::Disk
  end

  def initialize options={}
    @storage_class = options.fetch(:storage_class, storage_class)
    @processed  = @repaired = true
    super
  end

  def storage_class
    @storage_class || self.class.storage_class
  end

  def storage
    @storage ||= self.class.storage_class.new(self)
  end

  protected
    def determine_last_modified_date
      @last_modified ||= storage.mtime
    end
end
