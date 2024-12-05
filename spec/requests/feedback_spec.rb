require 'rails_helper'

RSpec.describe "Feedbacks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/feedback/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/feedback/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/feedback/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/feedback/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
