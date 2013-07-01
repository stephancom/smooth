require 'sinatra'

module Smooth
  module MetaData
    class Application < Sinatra::Base
      def resources
        @resources ||= Smooth::MetaData.resources
      end

      get "/" do
        content_type :json
        resources.to_json
      end

      get "/:resource" do

        content_type :json
        camelized = params[:resource].camelize
        info = resources[camelized]

        if !info
          halt 404 and return
        end

        info.to_json
      end
    end
  end
end
