module Smooth
  module Presentable
    class ApiEndpoint < Sinatra::Base

      get "/:resource" do
        halt 404 unless valid_resource?
        index.to_json
      end

      get "/:resource/:presenter" do
        halt 404 unless valid_resource?
        index.to_json
      end


      def resource_model
        params[:resource] && params[:resource].singularize.camelize.constantize rescue nil
      end

      def valid_resource?
        resource_model && resource_model.ancestors.include?(Smooth::Presentable)
      end

      def presenter_format
        params[:presenter] || params[:presenter_format] || :default
      end

      def base_scope
        resource_model
      end

      def current_user_role
        :default
      end

      def index
        base_scope.present(params)
          .as(presenter_format)
          .to(current_user_role).results
      end

      def show
        record = base_scope.find(params[:id])
        record.present_as(presenter_format)
      end

    end
  end
end
