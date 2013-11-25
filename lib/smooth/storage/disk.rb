class Smooth::Storage::Disk < Smooth::Storage
  attr_reader :path

  def initialize(backend)
    @key    = backend.try(:id) || object_id
    @path   = Smooth.data_directory.join("#{ @key }.json")
    @last_persisted_at = File.mtime(@path).utc rescue Time.now.utc

    FileUtils.mkdir_p(Smooth.data_directory)

    super
  end

  def restore
    contents    = IO.read(path) rescue "{}"
    self.store  = JSON.parse(contents)
  end

  def timestamp!
    self.last_persisted_at = Time.now.utc
    FileUtils.touch(path)
  end

  def persist
    File.open(path,'w+') do |fh|
      json = JSON.generate(self.store)
      fh.puts(json)
    end

    timestamp!

    true
  end
end
