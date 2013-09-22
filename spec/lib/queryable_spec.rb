require "spec_helper"

describe Smooth::Queryable do
  class QueryableHelper < ActiveRecord::Base
    self.table_name = "people"

    include Smooth::Queryable

    can_be_queried_by :name
  end

  let(:q) { QueryableHelper }

  it "should register the resource with the smooth metadata registry" do
    Smooth::MetaData.available_resources.should include("QueryableHelper")
  end

  describe "Query Interface Metadata" do
    it "should store some settings" do
      q.smooth_queryable_settings.should be_a(Smooth::Queryable::Settings)
    end

    it "should expose the available query parameters " do
      q.queryable_keys.should include(:name)
    end
  end
end
