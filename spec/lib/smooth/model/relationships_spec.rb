require "spec_helper"

Smooth.namespace "SmoothSpec"

SmoothSpec.define "Kid" do
  attribute :id, Integer
  attribute :name, String
  belongs_to :parent
end

SmoothSpec.define "Parent" do
  attribute :id, Integer
  attribute :name, String
  has_many :kids
end

describe Smooth::Model::Relationships do
  before(:all) do
    @parent = SmoothSpec::Parent.create(name:"parent name")

    3.times do |n|
      SmoothSpec::Kid.create(name:"child #{n}",parent_id:@parent.id)
    end
  end

  it "should lookup the relationship class" do
    SmoothSpec::Parent.relationship_class_for("kids").should == SmoothSpec::Kid
    SmoothSpec::Parent.relationship_class_for("parent").should == SmoothSpec::Parent
  end

  it "should support has many" do
    @parent.kids.length.should == 3
  end

  it "should support belongs to" do
    SmoothSpec::Kid.first.parent.should be_a(SmoothSpec::Parent)
  end

  it "should record the belongs to relationships" do
    SmoothSpec::Kid.belongs_to_relationships.should_not be_empty
  end

  it "should record the has many relationships" do
    SmoothSpec::Parent.has_many_relationships.should_not be_empty
  end
end
