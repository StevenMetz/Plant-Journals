class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name image banner])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name image banner])
    end

end
