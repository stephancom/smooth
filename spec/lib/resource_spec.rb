require "spec_helper"

describe Smooth::Resource do
  class ResourceHelper < ActiveRecord::Base
    self.table_name = :people
    include Smooth::Resource
  end

  it "should be presentable" do
    ResourceHelper.should respond_to(:present)
    ResourceHelper.new.should respond_to(:present_as)
  end

  it "should be queryable" do
    ResourceHelper.should respond_to(:query)
  end
end
