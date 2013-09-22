require 'spec_helper'
require 'tmpdir'

describe Smooth::Backends::File do
  before(:all) do
    @tmpdir = File.join(Dir::tmpdir, "#{ Time.now.to_i }")
    FileUtils.mkdir_p(@tmpdir)
  end

  after(:all) do
    FileUtils.rm_rf(@tmpdir)
  end

  let(:backend) do 
    Smooth::Backends::File.new(namespace:"test",data_directory: @tmpdir)
  end

  it "should not be throttled by default" do
    backend.should_not be_throttled
  end

  it "should be throttled after a flush" do
    backend.send(:flush)
    backend.should be_throttled
  end

  it "should have a storage path" do
    backend.storage_path.should include("test.json")
  end

  it "should not persist its data on disk after every write" do
    backend.create(:attribute=>"delta")
    IO.read(backend.storage_path).should_not include("delta")
  end

  it "should persist its data on disk after being flushed" do
    backend.create(attribute:"charlie") && backend.send(:flush, true)
    IO.read(backend.storage_path).should include("charlie")
  end

  it "should flush periodically" do
    backend.setup_periodic_flushing
    backend.instance_variable_get("@periodic_flusher").should be_a(Thread)
  end

end