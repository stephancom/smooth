require "spec_helper"

Smooth.namespace "SpecModel"

SpecModel.define "Person" do
  use :active_record
end

describe Smooth::ActiveRecordBackend do
  it "should use the specific backend" do
    SpecModel::Person.collection.backend.should be_a(Smooth::ActiveRecordBackend)
  end

  it "should detect the underlying active record model" do
    SpecModel::Person.collection.backend.active_record.should == ::Person
  end

  it "should delegate to the underlying active record" do
    SpecModel::Person.find(1).should be_present
  end
end
