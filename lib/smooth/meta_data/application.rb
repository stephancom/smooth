require 'sinatra'
module Smooth
  module MetaData
    class Application < Sinatra::Base
      def resources
        @resources ||= Smooth::MetaData.resources
      end

      get "/" do
        resources.to_json
      end

      get "/:resource" do
        camelized = params[:resource].camelize
        info = resources[camelized]

        if info
          info.to_json
        else
          halt 404
        end
      end
    end
  end
end
