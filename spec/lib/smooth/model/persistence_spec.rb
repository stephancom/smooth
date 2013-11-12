require "spec_helper"

Smooth.namespace "SmoothSpec"

SmoothSpec.define "Book" do
  attribute :name, String
end

describe Smooth::Model::Persistence do
  it "should create a new model" do
    book = SmoothSpec::Book.create(name:"Animal Farm")
    book.should be_persisted
  end
end
