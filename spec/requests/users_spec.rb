require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryBot.create(:user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end
  describe "POST #create" do
    context "With Valid Parameters" do
      it "creates a new user" do
        post :create, params: { user: { email: "test@test.com", name: "Steven", password: "password", password_confirmation: "password" } }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to eq('Success')
        expect(json_response['status']['data']).to be_present
      end
    end

    context "With Invalid Parameters" do
      it "does not create a new user" do
        post :create, params: { user: { email: "invalid_email", password: "password", password_confirmation: "password" } }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to include("Something went wrong Email is invalid")
      end
    end
  end
  describe "DELETE #destroy" do
    let(:user) { create(:user) }

    it "destroys user's account" do
      sign_in user
      delete :delete_user, params: { id: user.id }
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(json_response['status']['message']).to include("Successfully deleted user")
    end
  end
end
