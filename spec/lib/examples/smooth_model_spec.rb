require "spec_helper"

class SmoothModel < Smooth::Model
  attribute :name, String
  attribute :age, Integer
end

describe "The Smooth Model system" do
  it "should respond to the attribute defined" do
    model = SmoothModel.new(name:"Jonathan Soeder",age: Time.now.year - 1980)
    model.name.should == "Jonathan Soeder"
  end
end
