require 'spec_helper'

describe Smooth::Backends::ActiveRecord do
  let(:backend) do
    Smooth::Backends::ActiveRecord.new(model:Person)    
  end

  it "should decorate the model with the smooth query method" do
    backend.model.should respond_to(:smooth_query)
  end

  it "should perform a query against the model" do
    backend.query.count.should == 10
  end


end