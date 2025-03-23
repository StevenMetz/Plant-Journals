class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.find_by(email: resource_params[:email])
    if resource.present?
      resource.send_reset_password_instructions

      render json: {
        message: 'Password reset instructions sent successfully',
        status: 'success',
        email: resource.email.gsub(/(?<=.{2}).(?=.{2})/,'*')
      }, status: :ok
    else
      render json: {
        message: 'No user found with that email',
        status: 'error'
      }, status: :not_found
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      render json: {
        message: 'Password reset successfully',
        status: 'success'
      }, status: :ok
    else
      render json: {
        errors: resource.errors.full_messages,
        status: 'error'
      }, status: :unprocessable_entity
    end
  end

  private

    def resource_params
      params.require(:user).permit(:email, :reset_password_token, :password, :password_confirmation)
    end
end
