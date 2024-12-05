require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, email: "to@example.org") }
  let(:token) { "reset_token_123" }
  let(:other_user) {create(:user)}
  let(:plant_journal) { create(:plant_journal, user: user) }
  let(:plant) { create(:plant, user: user) }

  describe "forgot_password_email" do
    let(:mail) { UserMailer.reset_password_instructions(user, token) }

    it "renders the headers" do
      expect(mail.subject).to eq("Reset Your Password Instructions")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials.EMAIL_USER])
    end

    it "renders the correct reset password link in the HTML body" do
      expect(mail.html_part.body.encoded).to match(token)
    end
  end

  describe "welcome_email" do
    let(:mail) { UserMailer.welcome_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome email")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials.EMAIL_USER])
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

  describe "Shared Journal Email" do
    let(:mail) { UserMailer.shared_journal_email(user,other_user,plant_journal.title) }

    it "renders the headers" do
      expect(mail.subject).to eq("A new plant journal was shared with you")
      expect(mail.to).to eq([other_user.email])
      expect(mail.from).to eq([Rails.application.credentials.EMAIL_USER])
    end
    it "renders the plaintext body" do
      expect(mail.text_part.body.encoded).to match("New journal shared with you")
      # expect(mail.text_part.body.encoded).to match(user.name)
      expect(mail.text_part.body.encoded).to match(other_user.name)
      expect(mail.text_part.body.encoded).to match(plant_journal.title)
      expect(mail.text_part.body.encoded).to match("The Botanical Buddies Team")
    end
    it "renders the HTML body" do
      expect(mail.html_part.body.encoded).to match("<h1>New journal shared with you")
      expect(mail.text_part.body.encoded).to match(user.name)
      expect(mail.html_part.body.encoded).to match(other_user.name)
      expect(mail.html_part.body.encoded).to match(plant_journal.title)
      expect(mail.html_part.body.encoded).to match("The Botanical Buddies Team")
    end
  end
end
