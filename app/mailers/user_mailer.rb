class UserMailer < ApplicationMailer
  # If you want to use Devise's mailer functionality
  include Devise::Mailers::Helpers

  def reset_password_instructions(record, token, _opts = {})

    @token = token
    @user = record
    @reset_password_url = "https://your-frontend.com/reset-password?token=#{@token}"

    mail(
      to: @user.email,
      subject: 'Reset Your Password Instructions',
      template_path: 'user_mailer',
      template_name: 'forgot_password_email'
    )
  end
  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Welcome email",
      template_path: "user_mailer",
      template_name: "welcome_email"
    )
  end
end
