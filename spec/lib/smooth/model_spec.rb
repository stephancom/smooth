require "spec_helper"

SmoothModelTest = Class.new(Smooth::Model)

describe SmoothModelTest do
  it "should have a collection class" do
    SmoothModelTest::Collection.model.should == SmoothModelTest
  end
end
