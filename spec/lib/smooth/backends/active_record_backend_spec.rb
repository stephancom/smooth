require "spec_helper"

Smooth.namespace "SpecModel"

SpecModel.define "Person" do
  use :active_record, :attributes => true
end

describe Smooth::ActiveRecordBackend do
  it "should pick up the attributes of the underlying model" do
    SpecModel::Person.attribute_names.should include(:name,:legit,:salary,:parent_id)
  end

  it "should detect ative record backend" do
    SpecModel::Person.should be_active_record_backend
  end

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
