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
      SmoothModel.serializer_class = SmoothModelSerializer
      hash = SmoothModel.new(:name => "Jonathan").to_hash
      binding.pry

      hash[:name].should == "Jonathan"
    end

    it "should allow me to swap out the serializer" do
      class CustomSerializer < Smooth::Serializer
        attributes :full_name, :name, :id
        root :blah

        def full_name
          "#{ object.name }-#{ object.id }"
        end
      end

      SmoothModel.serializer_class = CustomSerializer

      model = SmoothModel.new(name:"Jonathan",id:1)

      model.as_json.should have_key(:blah)

      SmoothModel.serializer_class = SmoothModelSerializer
    end

  end
end
