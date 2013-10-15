require "sinatra/base"
require "sinatra/json"

module Smooth
  class Endpoint < Sinatra::Base
    helpers Sinatra::JSON

    def self.interface_for(model_class, options={})
      collection    = model_class.collection
      resource_name = options.fetch(:resource_name, collection.namespace)
      prefix        = options.fetch(:prefix, "/smooth/api/v1")

      get "#{ prefix }/#{ resource_name }" do
        json collection.query(params)
      end

      get "#{ prefix }/#{ resource_name }/:id" do
        json collection.show(params[:id])
      end

    end
  end
end
