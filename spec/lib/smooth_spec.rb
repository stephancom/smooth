require "spec_helper"

describe Smooth do
  it "should have a setting for its data directory" do
    Smooth.data_directory.should_not be_nil
  end

  it "should allow me to set the data directory" do
    Smooth.data_directory = File.join(ENV['HOME'],'.smooth-test')
    Smooth.data_directory.should match(/smooth-test/)
  end
end

