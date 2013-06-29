require "spec_helper"

describe Smooth::MetaData do

  class MetaDataHelper < ActiveRecord::Base
    self.table_name = "people"

    include Smooth::Presentable

    can_be_queried_by :name
  end

  let(:meta_data) { Smooth::MetaData["MetaDataHelper"] }

  it "should be able to tell me all of the smooth resources" do
    Smooth::MetaData.available_resources.should include("MetaDataHelper")
  end

  it "should tell me all of the presenters for a given resource" do
    meta_data.presenters.should include(:default)
  end

  it "should tell me all of the columns a resource can be queried by" do
    meta_data.queryable_parameters.should include(:name)
  end

  it "should give me a hash object of all of the query settings" do
    meta_data.queryable_settings.should be_a(Hash)
  end
end

