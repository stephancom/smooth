require "spec_helper"

describe SmoothModel::Collection do
  describe "Backend Relationship" do
    it "should have a memory backend by default" do
      SmoothModel.collection.backend_class.should == Smooth::MemoryBackend
    end
  end

  describe "Model Relationship" do
    it "should know its model" do
      SmoothModel.collection.model_class.should == SmoothModel
    end

    it "should know its namespace" do
      SmoothModel.collection.namespace.should == SmoothModel
    end
  end
end
