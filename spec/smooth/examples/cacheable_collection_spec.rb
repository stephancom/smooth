require 'spec_helper'

describe "Cacheable Collections" do
  let(:collection) do  
    Smooth::Collection.new(backend: "active_record", backend_options:{model:Person}, cache: "redis")
  end

  let(:hit) do
    query = Smooth::Collection::Query.new(smooth:"baby",yeah:"son")
    collection.send(:cache_adapter).write(query.cache_key, "[{id:1}]")
    query
  end

  let(:miss) do
    Smooth::Collection::Query.new(miss:"this",query:"awww")      
  end

  it "should avoid the backend in a cache hit" do
    collection.backend.should_not_receive(:query)
    collection.query(hit)
  end

  it "should fallback to the backend if there is a cache miss" do
    collection.backend.should_receive(:query)
    collection.query(miss)
  end
end