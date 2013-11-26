require "spec_helper"

Smooth.namespace("CodeGen")

CodeGen.define "Language" do
  attribute :name, String
  has_many :files
  validates_presence_of :name
end

CodeGen.define "File" do
  attribute :version, Integer
  attribute :name, String
  belongs_to :language
  validates_numericality_of :version
end

describe "Code Generators" do
  let(:ember) { Smooth::CodeGenerators.for(:ember) }

  it "should have multiple assets for a namespace" do
    ember.source = CodeGen
    ember.assets.length.should == 2
  end

  it "should have a single asset for a model" do
    ember.source = CodeGen::File
    ember.assets.length.should == 1
  end

  it "should render the assets" do
    ember.source = CodeGen
    ember.to_s.should match('CodeGen.File')
    ember.to_s.should match('CodeGen.Language')
  end
end
