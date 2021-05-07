class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    respond_to :json
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    def render_resource(resource)
      if resource.errors.empty?
        render json: resource
      else
        validation_error(resource)
      end
    end

    def validation_error(resource)
      render json: {
        errors: [
          {
            status: '400',
            title: 'Bad Request',
            detail: resource.errors,
            code: '100'
          }
        ]
      }, status: :bad_request
    end

    protected
    
    def configure_permitted_parameters
      update_attrs = [:password, :password_confirmation]
      devise_parameter_sanitizer.permit(:account_update, keys: update_attrs)
      devise_parameter_sanitizer.permit(:sign_up, keys: [:phone, :username, :email, :name])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :phone, :email, :name])
    end
end
