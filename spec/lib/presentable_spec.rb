require "spec_helper"

describe Smooth::Presentable do
  before(:all) do
    Person.send(:include, Smooth::Presentable)
  end

  it "should register the resource with the smooth metadata registry" do
    Smooth::MetaData.available_resources.should include("Person")
  end

  it "should allow me to present a resource as a given format" do
    records = Person.present({}).as(:default)
    records.results.should be_a(Array)
  end

  context "Custom Presenters" do
    class PresentableHelper < ActiveRecord::Base
      self.table_name = "people"

      include Smooth::Presentable
      include Smooth::Queryable

      def friend
        Friend.new(name:"Jonathan Soeder")
      end
    end

    class PresentableHelperPresenter
      def self.default
        [:name]
      end

      def self.custom
        [
          :name,
          {
            :attribute => :friend,
            :method => :friend,
            :presenter => :custom
          }
        ]
      end
    end

    class Friend < ActiveRecord::Base
      self.table_name = "people"
      include Smooth::Presentable
      include Smooth::Queryable
    end

    class FriendPresenter
      def self.custom
        [:name]
      end
    end

    it "should use a role based presenter format if specified" do
      FriendPresenter.should_receive(:role_custom).at_least(:once)
      Friend.present({}).as(:custom).to(:role).to_a
    end

    it "should fall back to the non-role based presenter if there isn't a format specifically defined for the role" do
      FriendPresenter.should_receive(:custom).at_least(:once)
      Friend.present({}).as(:custom).to(:default).to_a
    end

    it "should use the default format if an unknown format is requested" do
      lambda {
        PresentableHelper.new(name:"Sup").present_as(:sheeeeit)
      }.should_not raise_error
    end

    it "should allow me to nest other presenter calls" do
      record = PresentableHelper.new(name:"Tupac")
      presented = record.present_as(:custom)
      presented[:friend][:name].should == "Jonathan Soeder"
    end
  end
end
