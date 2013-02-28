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

  it "should track the maximum updated at" do
    backend.maximum_updated_at.should >= Time.now.to_i
  end

  it "should update the maximum updated at timestamp" do
    current = backend.maximum_updated_at
    sleep(1)
    backend.create(attribute:"indigo")
    backend.maximum_updated_at.should > current
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

  it "should allow me to create records" do
    result = backend.create(attribute: "alpha")
    fetched = backend.show(result[:id])
    fetched.should be_present
    fetched[:attribute].should == "alpha"
  end

  it "should timestamp creates" do
    current = Time.now.to_i
    backend.create(attribute:"lima")[:created_at].should >= current
  end

  it "should timestamp updates" do
    result = backend.create(attribute:"x-ray")
    sleep(1)
    backend.update(result.merge(:name=>"whiskey"))
    backend.show(result[:id])[:updated_at].should > result[:created_at]
  end

  it "should assign an id to records" do
    result = backend.create(attribute:"hotel")
    result[:id].should_not be_nil
  end

  it "should allow me to destroy records" do
    result = backend.create(attribute:"yankee")
    backend.destroy(result[:id])
    backend.show(result[:id]).should be_nil
  end

  it "should show me a record" do
    result = backend.create(attribute:"walt whitman")
    result[:id].should be_present
    backend.show(result[:id]).should be_a(Hash)
  end

  it "should allow me to update records" do
    result = backend.create(attribute:"foxtrot",name:"wilco") 
    backend.update result.merge(name:"mermaid")
    fetched = backend.show(result[:id])
    fetched[:name].should == "mermaid"
  end

  it "should flush periodically" do
    backend.setup_periodic_flushing
    backend.instance_variable_get("@periodic_flusher").should be_a(Thread)
  end

end