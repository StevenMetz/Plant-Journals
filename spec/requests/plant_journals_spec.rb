require 'rails_helper'

RSpec.describe PlantJournalsController, type: :controller do
  let(:user) { create(:user) }
  let(:plant_journal) { create(:plant_journal, user_id: user.id) }
  let(:plant) { create(:plant, plant_journal_id: plant_journal.id, user_id: user.id) }

  before do
    sign_in user
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: plant_journal.id }, as: :json
      expect(response).to be_successful
    end

    it "assigns the requested plant journal to @plant_journal" do
      get :show, params: { id: plant_journal.id }, as: :json
      expect(controller.instance_variable_get(:@plant_journal)).to eq(plant_journal)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new plant journal" do
        expect {
          post :create, params: { title: "New Plant Journal", user_id: user.id }, as: :json
        }.to change(PlantJournal, :count).by(1)
        expect(response).to be_successful
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity status" do
        post :create, params: { title: nil, user_id: user.id }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #delete_plant" do
    it "removes the plant from the plant journal" do
      delete :destroy_plant, params: {plant_journal_id: plant_journal.id, id: plant.id }, as: :json
      expect(plant.reload.plant_journal_id).to be_nil
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    it "destroys the plant journal" do
      delete :destroy, params: {id: plant_journal.id}
      expect(response).to be_successful
      expect(PlantJournal.exists?(plant_journal.id)).to be_falsey
    end
  end
end
