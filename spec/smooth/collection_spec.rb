require "spec_helper"

describe Smooth::Collection do
  let(:smooth) { Smooth::Collection.new(namespace: "test") }
  
  it "should have a file backend by default" do
    smooth.backend.should be_a(Smooth::Backends::File)
  end

  it "should have the concept of a url" do
  	smooth.url.should match(/test/)
  end


end
