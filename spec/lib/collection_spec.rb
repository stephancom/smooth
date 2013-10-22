require "spec_helper"

describe Smooth::Collection do
  class ModelHelper < Smooth::Model
    attribute :id, String
    attribute :name, String
  end

  let(:collection) { Smooth::Collection.new(namespace: "test", model_class: ModelHelper) }

  before(:all) do
    5.times {|n| collection.backend.create(name:"Item #{ n }")}
  end

  it "should set an id on the model when it is saved" do
    model = collection.add(name:"Item 9")
    $k = true
    model.sync
    $k = false

    model.id.should_not be_nil
  end

  it "should add a model to the collection but not save it" do
    model = collection.add(name: "Item 8")
    model.should be_a(Smooth::Model)
    model.name.should == "Item 8"
    model.id.should be_nil
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

  it "should empty the models when resetting" do
    collection.reset([])
    collection.models.should be_empty
  end

  describe "The find methods" do
    it "should find by id" do
      collection.find(1).name.should == "Item 0"
    end

    it "should find by name" do
      collection.find_by(:name,"Item 0").id.to_i.should == 1
    end
  end

  describe "The Sync Interface" do
    it "should read the models from the collection" do
      collection.reset([])
      collection.sync
      collection.models.length.should >= 5
    end
  end
end
