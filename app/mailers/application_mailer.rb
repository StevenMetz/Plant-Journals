class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.EMAIL_USER
  layout "mailer"
end
