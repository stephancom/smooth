require "spec_helper"

describe "Swappable Backends" do
  class ModelHelper < Smooth::Model
    attribute :id
    attribute :name
  end

  let(:records) do
    3.times.collect do |n|
      {
        id: n,
        name: "person #{ n }"
      }
    end
  end

  let(:redis) { Smooth::Collection.new(namespace:"test",backend:"redis",model_class: ModelHelper) }
  let(:redis_namespace) { Smooth::Collection.new(namespace:"test",backend:"redis_namespace", model_class: ModelHelper) }
  let(:file) { Smooth::Collection.new(namespace:"test",backend:"file",model_class:ModelHelper) }

  before(:each) { Redis.new.flushdb }

  it "should have the correct backend" do
    redis.backend.should be_a(Smooth::Backends::Redis)
    redis_namespace.backend.should be_a(Smooth::Backends::RedisNamespace)
    file.backend.should be_a(Smooth::Backends::File)
  end

  it "should encode everything the same" do
    records.each do |hash|
      redis.backend.create(hash)
      file.backend.create(hash)
      redis_namespace.backend.create(hash)
    end

    expected = [
      "person 0",
      "person 1",
      "person 2"
    ].to_set

    redis.models.map(&:name).to_set.should == expected
    redis_namespace.models.map(&:name).to_set.should == expected
    file.models.map(&:name).to_set.should == expected
  end
end
