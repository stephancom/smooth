require "spec_helper"

Smooth.namespace("Specs")

Specs.define "Parent" do
  attribute :name
  has_many :models
end

Specs.define "Model" do
  attribute :name, String
  attribute :camelize_this, DateTime
  attribute :version, Integer
  attribute :schema, Hash
  attribute :items, Array
  belongs_to :parent
  has_many :models
end

describe Smooth::CodeGenerators::EmberModel do
  let(:generator) { Smooth::CodeGenerators::EmberModel.generate(Specs::Model) }
  let(:output) { generator.render }

  it "should have a cache key" do
    generator.cache_key.should match(/specs-model/)
  end

  it "should have a template" do
    File.exists?(generator.template_file).should be_true
  end

  it "should render some output" do
    output.should match('Specs.Model')
    output.should match('DS.Model.extend')
  end

  it "should camelize the attribute names" do
    output.should match('camelizeThis')
  end

  it "should get the attribute types correct" do
    output.lines.grep(/camelizeThis/).join.should match('date')
    output.lines.grep(/schema/).join.should match('embedded')
    output.lines.grep(/items/).join.should match('embedded')
    output.lines.grep(/version/).join.should match('number')
    output.lines.grep(/name/).join.should match('string')
  end

  it "should define belongs to relationships" do
    output.should match(/hasMany.+Specs\.Model/)
  end
end
