# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :authenticate_user!
  include RackSessionsFix
  respond_to :json
  # POST /resource
  def create
    super do |user|
      if user.persisted?
        UserMailer.welcome_email(user).deliver_now
      end
    end
  end


  def delete_user
    user = User.find_by(id: current_user.id)

    if user.nil?
      render json: { message: "User not found" }, status: :not_found
      return
    end

    if current_user.id != user.id
      render json: { message: "Unauthorized to delete this user" }, status: :unauthorized
      return
    end

    begin
      User.transaction do
        SharedJournal.where(plant_journal_id: user.plant_journals.pluck(:id)).destroy_all
        user.shared_journals.destroy_all
        user.plant_journals.destroy_all
        user.notifications.destroy_all
        user.plants.destroy_all
        user.feedbacks.destroy_all
        user.image.purge if user.image.attached?
        user.banner.purge if user.banner.attached?
        user.destroy!
      end

      render json: {
        message: 'User and all associated data successfully deleted',
        status: :ok
      }
    rescue ActiveRecord::RecordNotDestroyed => e
      Rails.logger.error("Failed to delete user: #{e.message}")
      Rails.logger.error("Validation errors: #{e.record.errors.full_messages}")
      render json: {
        message: "Unable to delete user and associated data",
        errors: e.record.errors.full_messages
      }, status: :unprocessable_entity
    rescue StandardError => e
      render json: {
        message: "An error occurred while deleting the user",
        error: e.message
      }, status: :internal_server_error
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
