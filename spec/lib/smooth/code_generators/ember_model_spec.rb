require "spec_helper"

Smooth.namespace("Specs")

Specs.define "Parent" do
  attribute :name
  has_many :models
end

Specs.define "Model" do
  attribute :name, String
  belongs_to :parent
  has_many :models
end

describe Smooth::CodeGenerators::EmberModel do
  let(:generator) { Smooth::CodeGenerators::EmberModel.generate(Specs::Model) }

  it "should have a cache key" do
    generator.cache_key.should match(/specs-model/)
  end

  it "should have a template" do
    File.exists?(generator.template_file).should be_true
  end

  it "should render some output" do
    generator.render.should match('Specs.Model')
    generator.render.should match('DS.Model.extend')
  end
end
