require "spec_helper"

Smooth.namespace "SmoothSpec"

SmoothSpec.define "SampleModel" do
  attribute :something, String, :default => "Awesome"
  attribute :status, String
  attribute :default_type

  validates_presence_of :status
  validates_inclusion_of :status, :in => ["VERIFIED"]

end

describe SmoothModel do
  describe "Namespaces" do
    it "should know its namespace" do
      SmoothSpec::SampleModel.namespace.should == SmoothSpec
    end
  end

  describe "Validations" do
    it "should support presence validations" do
      SmoothSpec::SampleModel.new.should be_invalid
      SmoothSpec::SampleModel.new(:status=>"VERIFIED").should be_valid
    end

    it "should support inclusion validations" do
      SmoothSpec::SampleModel.new(status:"VERIFIED").should be_valid
      SmoothSpec::SampleModel.new(status:"NOT_VERIFIED").should be_invalid
    end
  end

  describe "Attributes" do
    it "should have attribute names" do
      attribute_names = SmoothSpec::SampleModel.attribute_names
      names = attribute_names & [:something,:default_type,:status]
      names.length.should == 3
    end

    it "should default type of string" do
      SmoothSpec::SampleModel.attribute_set.to_a.last.should be_a(Virtus::Attribute::String)
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
      model = SmoothModel.new(name:"Jonathan Soeder")
      hash = model.as_json
      hash[:smooth_model][:name].should == "Jonathan Soeder"
    end

    it "should allow me to swap out the serializer" do
      class CustomSerializer < ActiveModel::Serializer
        attributes :full_name, :name, :id
        root :blah

        def full_name
          "#{ object.name }-#{ object.id }"
        end
      end

      SmoothModel.serializer_class = CustomSerializer

      model = SmoothModel.new(name:"Jonathan",id:1)

      model.as_json.should have_key(:blah)
      model.as_json[:blah][:name].should == "Jonathan"
      model.as_json[:blah][:full_name].should == "Jonathan-1"

      SmoothModel.serializer_class = SmoothModelSerializer
    end

  end
end
