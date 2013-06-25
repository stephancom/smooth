module Smooth
  module Presentable
    module Controller
      extend ActiveSupport::Concern

      included do
        respond_to :json
        class_attribute :resource
      end

      def index
        records = base_scope.present(params)
                      .as(presenter_format)
                      .to(current_user_role)

        respond_with(records)
      end

      protected

        def current_user_role
          (current_user && current_user.try(:role)) || :default
        end

        def presenter_format
          params[:presenter] || params[:presenter_format] || :default
        end

        def base_scope
          resource_model
        end

        def resource_model
          resource = self.class.resource || params[:resource]
          "#{ resource }".singularize.camelize.constantize
        end
    end
  end
end
