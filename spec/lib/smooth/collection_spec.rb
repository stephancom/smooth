require "spec_helper"

describe SmoothModel::Collection do
  describe "Backend Relationship" do
  end

  describe "Model Relationship" do
    it "should have a model class" do
      SmoothModel::Collection.model_class.should == SmoothModel
    end
  end
end
