class UserMailer < ApplicationMailer
  # If you want to use Devise's mailer functionality
  include Devise::Mailers::Helpers

  def reset_password_instructions(record, token, _opts = {})

    @token = token
    @user = record

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

  def shared_journal_email(user,other_user, journal)
    @journal = journal
    @user = user
    @other_user = other_user
    mail(
      to: @other_user.email,
      subject: "A new plant journal was shared with you",
      template_path: "user_mailer",
      template_name: "shared_journal_email"
    )
  end
end
