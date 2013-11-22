require "spec_helper"

Smooth.namespace "SpecModel"

SpecModel.define "RedisModel" do
  attribute :name, String
  attribute :settings, Hash
end

SpecModel::RedisModel::Backend = Class.new(Smooth::RedisBackend)

describe Smooth::RedisBackend do
  let(:backend) { SpecModel::RedisModel::Backend.new(model:SpecModel::RedisModel) }

  it "should have an id" do
    backend.id.should be_present
  end

  it "should persist records" do
    backend_one = SpecModel::RedisModel::Backend.new(model:SpecModel::RedisModel)
    backend_two = SpecModel::RedisModel::Backend.new(model:SpecModel::RedisModel)

    backend_one.create(name:"My Dude")
    results = backend_two.all
    results.select! {|h| h.fetch(:name, nil) == "My Dude" }
  end

  it "should increment ids using the redis counter" do
    model = SpecModel::RedisModel.create(name:"Jonathan Soeder")
    model[:id].should >= 1
  end
end
