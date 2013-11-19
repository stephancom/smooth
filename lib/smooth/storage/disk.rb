class Smooth::Storage::Disk < Smooth::Storage
  attr_reader :path

  def initialize(backend)
    @key    = backend.try(:id) || object_id
    @path   = Smooth.data_directory.join("#{ @key }.json")
    restore
  end

  def restore
    contents    = IO.read(path) || "{}"
    self.store  = JSON.parse(contents)
  end

  def persist
    File.open(path,'w+') do |fh|
      json = JSON.generate(self.store)
      fh.puts(json)
    end
    true
  end
end
