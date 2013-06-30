require "spec_helper"

describe Smooth::MetaData::Application do
  include Rack::Test::Methods

  def app
    Smooth::MetaData::Application.new
  end

  class MetaHelperOne < ActiveRecord::Base
    include Smooth::Presentable
    self.table_name = :people
    can_be_queried_by :name
  end

  class MetaHelperTwo < ActiveRecord::Base
    include Smooth::Presentable
    self.table_name = :people
    can_be_queried_by :name
  end

  it "should return a list of resources" do
    get "/"
    response = JSON.parse(last_response.body)
    response.should be_a(Hash)
    response.keys.should include("MetaHelperOne")
  end

  it "should show info for a resource" do
    get "/meta_helper_one"
    response = JSON.parse(last_response.body)
    response.keys.should include("queryable")
    response.keys.should include("presentable")
  end

  it "should return 404" do
    get "/supboo"
    last_response.status.should == 404
  end
end
