require "smooth/storage"

class Smooth::FileBackend < Smooth::MemoryBackend
  class_attribute :storage_class

  def self.storage_class
    @storage_class || Smooth::Storage::Disk
  end

  def initialize options={}
    @processed  = @repaired = true
    super
  end

  protected
    def storage
      @storage ||= self.class.storage_class.new(self)
    end

    def determine_last_modified_date
      @last_modified ||= storage.mtime
    end
end
