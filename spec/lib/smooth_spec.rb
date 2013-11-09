require "spec_helper"

describe Smooth do
  it "should provision a namespace" do
    Smooth.namespace("Project").should respond_to(:define)
  end
end
