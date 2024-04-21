require 'rails_helper'

RSpec.describe PlantsController, type: :controller do
  let(:user) { create(:user) }
  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new plant" do
        plant_params = {
          title: "Test Plant",
          description: "This is a test plant",
          likes: 10,
          dislikes: 2,
          water_frequency: "Weekly",
          temperature: "Moderate",
          sun_light_exposure: "Partial Sun",
          user_id: user.id
        }
        expect {
          post :create, params: plant_params
        }.to change(Plant, :count).by(1)
      end

      it "returns a success response" do
        plant_params = {
          title: "Test Plant",
          description: "This is a test plant",
          likes: 10,
          dislikes: 2,
          water_frequency: "Weekly",
          temperature: "Moderate",
          sun_light_exposure: "Partial Sun",
          user_id: user.id
        }
        post :create, params: plant_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "does not create a new plant" do
        invalid_params = {
          title: "", # Missing required title
          description: "This is a test plant",
          likes: 10,
          dislikes: 2,
          water_frequency: "Weekly",
          temperature: "Moderate",
          sun_light_exposure: "Partial Sun"
        }
        expect {
          post :create, params: invalid_params
        }.not_to change(Plant, :count)
      end

      it "returns a bad request response" do
        invalid_params = {
            title: "", # Missing required title
            description: "This is a test plant",
            likes: 10,
            dislikes: 2,
            water_frequency: "Weekly",
            temperature: "Moderate",
            sun_light_exposure: "Partial Sun"
        }
        post :create, params: invalid_params
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
