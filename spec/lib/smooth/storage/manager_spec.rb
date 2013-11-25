require "spec_helper"

describe Smooth::Storage::Manager do
  it "should be a singleton" do
    Smooth::Storage.manager.should == Smooth::Storage::Manager.instance
  end
end
