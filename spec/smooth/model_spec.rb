require "spec_helper"

describe Smooth::Model do
  let(:model) { collection.models[0] || collection.add(name:"Item 1",id:1) }

  let(:collection) do
    collection = Smooth::Collection.new(namespace:"model:spec",backend:"file")

    5.times do |n|
      id = n + 1
      collection.backend.create(name:"Item #{ n }", id: id)
    end

    collection
  end

  it "should read its attributes from the collections data source" do
    new_model = Smooth::Model.new({id:1},collection: collection)
    new_model.fetch

    new_model.get("name").should == "Item 1"
  end

  it "should delegate its sync method to the collection" do
    collection.should_receive(:sync).with(:read,{id:1},{})
    model.sync(:read, {id:1}, {})
  end
end
