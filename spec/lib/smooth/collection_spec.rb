require "spec_helper"

Smooth.namespace("SpecModel")
SpecModel.define("Sample")

class SmoothModel::Collection < Smooth::Collection
  def boom!
    "bon apetit"
  end
end

class SmoothModel::Collection::Backend < Smooth::MemoryBackend
  def sup!
    "jmoney"
  end

  def self.sup?
    "biggie smalls is the illest"
  end
end

describe SmoothModel::Collection do
  let(:collection) { SmoothModel.collection }

  it "should use a custom defined collection class instead of the default" do
    collection.should respond_to(:boom!)
  end

  it "should allow for a custom defined backend class" do
    collection.backend_class.should_not == Smooth::MemoryBackend
    collection.backend_class.should respond_to(:sup?)
  end

  it "should create a custom backend instance" do
    well = collection.backend.sup!
    well.should == "jmoney"
  end

  it "should have a memory backend by default" do
    SpecModel::Sample::Collection.backend_class.should == Smooth::MemoryBackend
  end

  it "should have a backend" do
    SpecModel::Sample.collection.backend.should be_a(Smooth::MemoryBackend)
  end

  it "should know its model" do
    collection.model_class.should == SmoothModel
  end

  it "should know its namespace" do
    collection.namespace.should == SmoothModel
  end
end
