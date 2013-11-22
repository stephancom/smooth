require "spec_helper"

Smooth.namespace("Site")

Site.define "Component" do
  attribute :name, String
  attribute :type, String
  attribute :format, String
end

describe Smooth::Namespace do
  it "should lookup a model class by an alias" do
    Site.lookup_model_class_by("component").should == Site::Component
    Site.lookup_model_class_by("components").should == Site::Component
  end

  it "should create a new namespace to house models" do
    namespace = Smooth.namespace("Site")
    namespace.should respond_to(:define)
    Object.const_get("Site").should == namespace
  end

  it "should allow me to define models" do
    Site.define("Pages")
    defined?(Site::Pages).should be_true
  end

  it "should allow me to define a base model class" do
    BaseModel = Class.new(Smooth::Model)
    Site.define("Layouts", base: BaseModel)
    Site::Layouts.new.should be_a(BaseModel)
  end

  it "should allow me to specify config with the DSL" do
    Site.define "Theme" do
      attribute :name, String
      attribute :author, String
    end

    Site::Theme.attribute_names.should include(:name,:author)
  end
end
