require "spec_helper"

describe SmoothModel do
  describe "Attributes" do
    it "should have attribute names" do
      SmoothModel.attribute_names.should include(:name,:id)
    end
  end

  describe "Collection Adapter" do
    it "should have a collection class" do
      SmoothModel.collection_class.should == SmoothModel::Collection
    end

    it "should create an instance of the collection" do
      SmoothModel.new.collection.should be_a(SmoothModel::Collection)
    end
  end

  describe "Serialization" do
    it "should have a serializer class" do
      SmoothModel.serializer_class.should == SmoothModelSerializer
    end

    it "should contain the attributes of the model in the serializer" do
      hash = SmoothModel.new(:name => "Jonathan").as_json
      hash[:name].should == "Jonathan"
    end

  end
end
