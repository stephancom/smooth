require "spec_helper"

describe Smooth::Presentable do
  before(:all) do
    Person.send(:include, Smooth::Presentable)
  end

  it "should create a presenter class when one doesn't exist" do
    defined?(PersonPresenter).should be_present
  end

  it "should create a default presenter format" do
    PersonPresenter.should respond_to(:default)
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

    it "should allow me to nest other presenter calls" do
      record = PresentableHelper.new(name:"Tupac")
      presented = record.present_as(:custom)
      presented[:friend][:name].should == "Jonathan Soeder"
    end
  end
end
