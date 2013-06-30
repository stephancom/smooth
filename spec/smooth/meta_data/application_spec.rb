require "spec_helper"

describe Smooth::MetaData::Application do
  include Rack::Test::Methods

  def app
    Smooth::MetaData::Application
  end

  it "should return a list of resources" do
    get "/"
    response.should be_success
  end
end
