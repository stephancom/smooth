require "spec_helper"

describe Smooth::Model do

  class SmoothModelHelper < Smooth::Model
    attribute :id, String
    attribute :name, String
  end

  let(:model) { collection.models[0] || collection.add(name:"Item 1",id:1) }

  let(:collection) do
    collection = Smooth::Collection.new(namespace:"model:spec",backend:"file", model_class: SmoothModelHelper)

    5.times do |n|
      id = n + 1
      collection.backend.create(name:"Item #{ n }", id: id)
    end

    collection
  end

  it "should have basic attributes as configured" do
    SmoothModelHelper.new(name:"sup baby").name.should == "sup baby"
  end

  it "should read its attributes from the collections data source given an id" do
    new_model = SmoothModelHelper.new({id:1}, collection: collection)
    new_model.fetch
    new_model.name.should == "Item 0"
  end

  it "should save and update" do
    model = SmoothModelHelper.new({name:"j-money baby"}, collection: collection)
    model.name = "sup my boo"
    model.save

    collection.fetch
    collection.models.detect {|m| m.name == "sup my boo" }.should be_present
  end

  it "should save and create" do
    model = SmoothModelHelper.new({name:"j-money"}, collection: collection)
    model.save

    collection.models.detect {|m| m.name == "j-money" }.should be_present
    model.id.to_i.should >= 1
  end

  it "should delegate its sync method to the collection" do
    collection.should_receive(:sync)
    model.sync(:read, {id:1}, {})
  end

  it "should include additional methods" do
    hash = model.as_json(:methods=>[:is_new?])
    hash.should have_key(:is_new?)
  end

end
