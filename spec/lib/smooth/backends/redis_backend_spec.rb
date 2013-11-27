require "spec_helper"

Smooth.namespace "SpecModel"

SpecModel.define "RedisModel" do
  attribute :name, String
  attribute :settings, Hash
end

SpecModel::RedisModel::Backend = Class.new(Smooth::RedisBackend)

describe Smooth::RedisBackend do
  let(:backend) { SpecModel::RedisModel::Backend.new(model:SpecModel::RedisModel) }

  it "should allow me to clear redis" do
    backend.send :delete!
    backend.should_not be_redis_object_present
  end

  it "should have a redis key" do
    backend.redis_key.should be_present
  end

  it "should support hash operations in redis" do
    backend.create(get:"Money")
    backend.should be_redis_object_present
  end

  it "should allow me to create records" do
    result = backend.create name:"Jonathan"
    result.should have_key(:id)
    backend.show(result[:id]).should have_key(:name)
  end

  it "should allow me to destroy records" do
    result = backend.create name:"Bruce Lee"
    id = result[:id]
    Redis.any_instance.should_receive(:hdel).with(backend.redis_key, id)
    backend.destroy(id).should be_present
  end

  it "should allow me to update records" do
    result = backend.create(name:"Leroy")
    backend.update(result[:id], name:"Machiavelli")
    backend.show(result[:id])[:name].should == "Machiavelli"
  end

  it "should persist records across backends with the same key" do
    backend_one = SpecModel::RedisModel::Backend.new(model:SpecModel::RedisModel)
    backend_two = SpecModel::RedisModel::Backend.new(model:SpecModel::RedisModel)

    backend_one.create(name:"My Dude")
    results = backend_two.all

    results.select! {|h| h.fetch(:name, nil) == "My Dude" }

    results.should_not be_empty
  end

  it "should increment ids using the redis counter" do
    model = SpecModel::RedisModel.create(name:"Jonathan Soeder")
    model[:id].should >= 1
  end
end
