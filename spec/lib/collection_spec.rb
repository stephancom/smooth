require "spec_helper"

describe Smooth::Collection do
  let(:collection) { Smooth::Collection.new(namespace: "test") }

  before(:all) do
    5.times {|n| collection.backend.create(name:"Item #{ n }")}
  end

  it "should add a model to the collection but not save it" do
    model = collection.add(name: "Item 8")
    model.should be_a(Smooth::Model)
    model.name.should == "Item 8"
  end

  it "should have a file backend by default" do
    collection.backend.should be_a(Smooth::Backends::File)
  end

  it "should have the concept of a url" do
  	collection.url.should match(/test/)
  end

  it "should fetch some models" do
    collection.fetch()
    collection.models.should_not be_empty
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

  describe "The Sync Interface" do
    it "should read the models from the collection" do
      collection.reset([])
      collection.sync
      collection.models.length.should == 5
    end
  end
end
