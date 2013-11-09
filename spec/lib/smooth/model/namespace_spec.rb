require "spec_helper"

Smooth.namespace("Site")

describe Smooth::Model::Namespace do
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
end
