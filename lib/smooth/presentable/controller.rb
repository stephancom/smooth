module Smooth
  module Presentable
    module Controller
      extend ActiveSupport::Concern

      included do
        respond_to :json
        class_attribute :resource
      end

      def index
        resource_model.present(params)
                      .as(presenter_format)
                      .to(current_user_role)
      end

      protected

        def current_user_role
          (current_user && current_user.try(:role)) || :default
        end

        def presenter_format
          params[:presenter] || params[:presenter_format] || :default
        end

        def resource_model
          "#{ self.class.send(:resource) }".constantize
        end
    end
  end
end
