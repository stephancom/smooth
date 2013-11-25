require "spec_helper"

Smooth.namespace("Specs").define("BackedModel") do
  use :file
end

describe Smooth::Backend do
  let(:backend) { Specs::BackedModel.collection.backend }

  it "should timestamp whenever it was persisted last" do
    storage = backend.storage
    storage.timer.should >= 0
  end
end

