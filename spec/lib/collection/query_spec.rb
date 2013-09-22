require "spec_helper"

describe Smooth::Collection::Query do
  let(:query) { Smooth::Collection::Query.new(key1:"value1", key2:"value2") }

  it "should generate a cache key" do
    query.cache_key.should == "key1:value1/key2:value2"
  end
end