require "spec_helper"

Smooth.namespace("DefaultBackends") do
  use :redis
end

DefaultBackends.define "Model" do
  attribute :name
end

DefaultBackends.define "OtherModel"

describe Smooth::Namespace do
  it "should tell me whatever namespaces are registered" do
    Smooth.namespaces.should include(DefaultBackends)
  end

  it "should tell me what models are defined" do
    DefaultBackends.models.should include(DefaultBackends::Model, DefaultBackends::OtherModel)
  end

  describe "setting config defaults" do
    it "should allow me to set a default backend class" do
      DefaultBackends.default_backend_class.should == Smooth::RedisBackend
    end

    it "should allow me to set a default backend class for all models" do
      DefaultBackends::Model.collection.backend_class.should == Smooth::RedisBackend
    end
  end
end
