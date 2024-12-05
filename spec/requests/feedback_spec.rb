require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  let(:user) { create(:user) }
  let(:feedback) {create(:feedback, user: user)}
  before do
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
  end
  let(:valid_attributes) {
    {
      message: "Great service!",
      rating: 5
    }
  }

  let(:invalid_attributes) {
    {
      user_id: nil,
      message: "",
      rating: nil
    }
  }

  describe "GET #index" do
    it "returns a successful response" do
      get :index, as: :json
      expect(response).to be_successful
    end

    it "assigns all feedbacks to @feedbacks" do
      feedback1 = user.feedbacks.create!(
      message: "Great service!",
      rating: 5
    )
      feedback2 = user.feedbacks.create!(
        message: "Another feedback",
        rating: 4
      )

      get :index, as: :json

      expect(assigns(:feedbacks)).to match_array([feedback1, feedback2])
    end

    it "renders the index template" do
      get :index, as: :json
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do

    it "returns a successful response" do
      get :show, params: { id: feedback.id }, as: :json
      expect(response).to be_successful
    end

    it "assigns the correct feedback to @feedback" do
      get :show, params: { id: feedback.id }, as: :json
      expect(assigns(:feedback)).to eq(feedback)
    end

    it "renders the show template" do
      get :show, params: { id: feedback.id }, as: :json
      expect(response).to render_template(:show)
    end

    it "returns not found for non-existent feedback" do
      get :show, params: { id: 9999 }, as: :json
      expect(response).to render_template(:show)
      expect(assigns(:feedback)).to be_nil
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Feedback" do
        expect {
          post :create, params: valid_attributes, as: :json
        }.to change(Feedback, :count).by(1)
      end

      it "returns a created status" do
        post :create, params: valid_attributes, as: :json
        expect(response).to have_http_status(:created)
      end

      it "returns a success message" do
        post :create, params: valid_attributes, as: :json
        expect(JSON.parse(response.body)['message']).to eq("Feedback created")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Feedback" do
        expect {
          post :create, params: invalid_attributes, as: :json
        }.to_not change(Feedback, :count)
      end

      it "returns an error message" do
        post :create, params: invalid_attributes, as: :json
        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq("Error submiting feedback")
        expect(response_body['errors']).to be_present
      end
    end
  end

  describe "PATCH #update" do

    context "with valid parameters" do
      it "updates the feedback" do
        patch :update, params: { id: feedback.id, message: "Updated message" }, as: :json
        feedback.reload
        expect(feedback.message).to eq("Updated message")
      end

      it "returns a success response" do
        patch :update, params: { id: feedback.id, message: "Updated message" }, as: :json
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the feedback" do
        original_message = feedback.message
        patch :update, params: { id: feedback.id, message: "" }, as: :json
        feedback.reload
        expect(feedback.message).to eq(original_message)
      end

      it "returns an error message" do
        patch :update, params: { id: feedback.id, message: "" }, as: :json
        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq("Error updating feedback")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:feedback) { create(:feedback, user: user)}

    it "destroys the requested feedback" do
      expect {
        delete :destroy, params: { id: feedback.id }, as: :json
      }.to change(Feedback, :count).by(-1)
    end

    it "returns a success message" do
      delete :destroy, params: { id: feedback.id }, as: :json
      response_body = JSON.parse(response.body)
      expect(response_body['message']).to eq("Feedback successfully removed")
    end

    it "returns not found for non-existent feedback" do
      delete :destroy, params: { id: 9999 }, as: :json
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(response_body['message']).to eq("Feedback not found")
    end
  end
end
