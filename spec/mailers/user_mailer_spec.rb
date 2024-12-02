require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, email: "to@example.org") }
  let(:token) { "reset_token_123" } # Mock token for reset email

  describe "forgot_password_email" do
    let(:mail) { UserMailer.reset_password_instructions(user, token) }

    it "renders the headers" do
      expect(mail.subject).to eq("Reset Your Password Instructions")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"]) # Adjust if needed
    end

    it "renders the correct reset password link in the HTML body" do
    # Check the HTML part of the email
      expect(mail.html_part.body.encoded).to match("href='https://your-frontend.com/reset-password?token=#{token}'")
    end
  end

  describe "welcome_email" do
    let(:mail) { UserMailer.welcome_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome email")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"]) # Adjust if needed
    end

    it "renders the plaintext body" do
      expect(mail.text_part.body.encoded).to match("Welcome to Botanical Buddies")
      expect(mail.text_part.body.encoded).to match("We're thrilled to have you join our community")
      expect(mail.text_part.body.encoded).to match("support@botanicalbuddies.com")
    end

    it "renders the HTML body" do
      expect(mail.html_part.body.encoded).to match('<h1 style="color: #2c7a7b;">Welcome to Botanical Buddies')
      expect(mail.html_part.body.encoded).to match("We're thrilled to have you join our community")
      expect(mail.html_part.body.encoded).to match("support@botanicalbuddies.com")
    end
  end
end
