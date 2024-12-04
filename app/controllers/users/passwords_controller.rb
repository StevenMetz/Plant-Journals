class Users::PasswordsController < Devise::PasswordsController
  # Disable CSRF protection for API routes


  # POST /password/reset
  def create
    # Find user by email
    self.resource = resource_class.find_by(email: resource_params[:email])

    if resource.present?
      # Generate and send reset instructions
      resource.send_reset_password_instructions

      render json: {
        message: 'Password reset instructions sent successfully',
        status: 'success',
        # Optionally send a masked email for security feedback
        email: resource.email.gsub(/(?<=.{2}).(?=.{2})/,'*')
      }, status: :ok
    else
      render json: {
        message: 'No user found with that email',
        status: 'error'
      }, status: :not_found
    end
  end

  # PUT /password/update
  def update
    # Reset password using token
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
