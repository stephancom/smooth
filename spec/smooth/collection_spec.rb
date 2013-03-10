require "spec_helper"

describe Smooth::Collection do
  let(:collection) { Smooth::Collection.new(namespace: "test") }
  
  before(:all) do  
    5.times do |n|
      collection.backend.create(name:"Item #{ n }")
    end
  end

  it "should have a file backend by default" do
    collection.backend.should be_a(Smooth::Backends::File)
  end

  it "should have the concept of a url" do
  	collection.url.should match(/test/)
  end

  it "should have an array of models" do
    collection.models.should be_an(Array)
  end

  it "should fetch some models" do
    collection.fetch()
    collection.models.length.should == 5
  end

  it "should allow me to query it" do
    collection.query(name: "Item 0").first[:name].should == "Item 0"
  end

  it "should allow me to reset it" do
    collection.fetch()
    collection.reset([{one:1}])
    collection.length.should == 1
  end

  it "should support redis backends" do 
    backend = Smooth::Collection.new(backend:"redis",namespace:"test").backend
    backend.should respond_to(:index)
  end

  it "should support active record backends" do
    lambda {
      Smooth::Collection.new(model: Person)
    }.should_not raise_error
  end

end
