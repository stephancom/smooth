require "spec_helper"

Smooth.namespace "Specs"

Specs.define "FileModel" do
  attribute :name
  use :file
end

describe Specs::FileModel do
  let(:collection) { Specs::FileModel.collection }

  it "should be backed by a file backend" do
    collection.backend_class.ancestors.should include(Smooth::FileBackend)
  end

  it "should have some storage" do
    collection.backend.storage.should be_a(Smooth::Storage::Disk)
  end
end

describe Smooth::FileBackend do

end
