require "spec_helper"

describe Smooth::Backends::Base do

  let(:backend) { Smooth::Backends::Base.new(namespace:"test") }

  it "should be queryable" do
    backend.query(attribute:"x-ray").should be_empty
    backend.create(attribute:"yankee")
    backend.query(attribute:"yankee").length.should == 1
  end

  it "should track the maximum updated at" do
    backend.maximum_updated_at.should >= Time.now.to_i
  end

  it "should update the maximum updated at timestamp" do
    current = backend.maximum_updated_at
    backend.create(attribute:"indigo")
    backend.maximum_updated_at.should >= current
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
    backend.update(result.merge(:name=>"whiskey"))
    backend.show(result[:id])[:updated_at].should >= result[:created_at]
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


end