# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, only: [:create]
  include RackSessionsFix
  respond_to :json
  # POST /resource/sign_in
  def create
    super
    Rails.logger.info("After super - current_user: #{current_user.inspect}")
    Rails.logger.info("After super - JWT Token: #{request.env['warden-jwt_auth.token']}")
  end

  # # DELETE /resource/sign_out
  def destroy
    Rails.logger.info("Destroy action called for user: #{current_user.inspect}")
    super
  end

  private
    def respond_with(resource, _opt = {})
      Rails.logger.info("Respond with resource: #{resource.inspect}")
      Rails.logger.info("JWT Token in respond_with: #{request.env['warden-jwt_auth.token']}")
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: {
          code: 200, message: 'Logged in successfully.',
          token: @token,
          data: {
            user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }
        }
      }, status: :ok
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                                Rails.application.credentials.devise_jwt_secret_key!).first

        current_user = User.find(jwt_payload['sub'])
      end

      if current_user
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end
end
