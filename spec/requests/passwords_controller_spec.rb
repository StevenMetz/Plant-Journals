require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  let(:user) { create(:user) }

  describe "Password Resets" do
    context "when a valid email is provided" do
      it "sends a reset token" do
        post :create, params: { user: {email: user.email} }, as: :json
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response["message"]).to eq("Password reset instructions sent successfully")
      end
    end
  end
  describe "Password Updates" do
    before do
      # Trigger the password reset email
      post :create, params: {user:{ email: user.email} }, as: :json
    end

    it "updates the password with a valid reset token" do
      # Intercept the email and extract the reset token
      mail = ActionMailer::Base.deliveries.last
      expect(mail).not_to be_nil
      token = mail.body.encoded.match(/reset-password\?token=([\w\-]*)/)[1].gsub(/^3D/,"")
      expect(token).not_to be_nil
      put :update, params: {
        user: {
          reset_password_token: token,
          password: "newpassword123",
          password_confirmation: "newpassword123"
        }
      }, as: :json
      pry
      # Verify the response
      expect(response).to have_http_status(:ok)
      expect(user.reload.valid_password?("newpassword123")).to be true
    end
  end
end
