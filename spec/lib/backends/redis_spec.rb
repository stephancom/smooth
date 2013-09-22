require "spec_helper"
require "fakeredis/rspec"

describe Smooth::Backends::Redis do
  let(:backend) do
    Smooth::Backends::Redis.new(namespace:"test")
  end

  before(:each) { backend.connection.flushdb }

  it "should allow me to create records" do
    result = backend.create(attribute:"alpha")
    fetched = backend.show(result[:id])
    fetched.should_not be_nil
  end

  it "should allow me to destroy records" do
    result = backend.create(attribute:"bravo")
    fetched = backend.show(result[:id])
    fetched.should be_present
    backend.destroy(fetched[:id]).should be_true
  end

  it "should allow me to update records" do
    record = backend.create(attribute:"yankee")
    fetched = backend.show(record[:id])
    backend.update(fetched.merge(attribute:"hotel"))
    backend.show(record[:id])[:attribute].should == "hotel" 
  end

  it "should allow me to view records" do
    record = backend.create(attribute:"updawg")
    backend.show(record[:id])[:attribute].should == "updawg"
  end

  it "should store an id" do
    record = backend.create(attribute:"supbaby")
    record[:id].should be_present
  end
end