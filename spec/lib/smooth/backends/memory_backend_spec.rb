require "spec_helper"

Smooth.namespace "SpecBackend"

SpecBackend.define "Model" do
  attribute :name, String
end

describe "The Memory Backend" do
  let(:collection) { SpecBackend::Model.collection }

  let(:backend) { collection.backend }

  it "should be the default kind of backend for a collection" do
    collection.backend_class.should == Smooth::MemoryBackend
  end

  it "should create records" do
    backend.create(name:"Jonathan")
    backend.map {|h| h[:name] }.should == ["Jonathan"]
  end
end
