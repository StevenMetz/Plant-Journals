# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :authenticate_user!
  include RackSessionsFix
  respond_to :json
  # POST /resource
  def create
    Rails.logger.info(params.inspect)
    super
  end

  def update_user
    user = User.find_by(id: current_user.id)
    if current_user
      user.image.attach(params[:image]) unless params[:image] == 'null'
      user.banner.attach(params[:banner]) unless params[:banner] == 'null'
      Rails.logger.info (" Params from user Update#{params}")
      user.update(user_params)
      if user.save
        respond_with(user, message: 'Succesfully Updated User')
      else
        render json: { message: "User couldn't be updated succesfully.", error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Unauthorized to update this user" }, status: :unauthorized
    end
  end
  def delete_user
    user = User.find_by(id: current_user.id)
    if current_user.id == user.id
      if user.destroy
        respond_with(user, message: 'Successfully deleted user', status: :ok)
      else
        respond_with(message: "Unable to delete user", error: user.errors.full_messages , status: :unprocessable_entity)
      end
    else
      render json: { message: "Unauthorized to update this user" }, status: :unauthorized
    end
  end
  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :image, :banner)
    end
    def respond_with(resource, opts = {})
      if resource.persisted?
        @token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
        headers['Authorization'] = @token

        render json: {
          status: {
            code: 200,
            message: opts[:message] || "Success",
            token: @token,
            data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }
        }
      else

        render json: {
          status: {
            message: opts[:message] ? "#{opts[:message]}. #{resource.errors.full_messages.to_sentence}" : "Something went wrong #{resource.errors.full_messages.to_sentence}"
          }
        }, status: opts[:status] || :unprocessable_entity
      end
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
          message: 'Account succesfully deleted'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't destroy account."
        }, status: :unauthorized
      end
    end
end
