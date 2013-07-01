require "spec_helper"

describe Smooth::Presentable::ApiEndpoint do
  include Rack::Test::Methods

  def app
    Smooth::Presentable::ApiEndpoint
  end


  class ApiHelper < ActiveRecord::Base
    self.table_name = :people
    include Smooth::Presentable

    def sup
      "hi #{ name }"
    end
  end

  class ApiHelperPresenter
    def self.custom
      [:name,{key:"sup"}]
    end
  end


  before(:all) do
    ApiHelper.delete_all
    ApiHelper.create(name:"Tahereh")
  end

  it "should return 404 for an invalid resource" do
    get "/sup_boo"
    last_response.status.should == 404
  end

  it "should allow me to query a resource" do
    get "/api_helper"
    last_response.status.should == 200
    response = JSON.parse(last_response.body)
    response.should be_a(Array)
    response.should_not be_empty
  end

  xit "should allow me to specify a custom presenter" do
    get "/api_helper/custom"

    last_response.status.should == 200
    response = JSON.parse(last_response.body)
    response.should be_a(Array)
    response.should_not be_empty
  end
end

