require 'rails_helper'

RSpec.describe PlantJournalsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:plant_journal) { create(:plant_journal, user: user) }
  let(:plant) { create(:plant, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a list of user plant journals' do
      journals = create_list(:plant_journal, 3, user: user)
      other_journal = create(:plant_journal, user: other_user)

      get :index, as: :json

      expect(response).to have_http_status(:success)
      expect(assigns(:plant_journals)).to match_array(journals)
      expect(assigns(:plant_journals)).not_to include(other_journal)
    end
  end

  describe 'GET #show' do
    context 'when user owns the journal' do
      it 'returns the requested plant journal' do
        get :show, params: { id: plant_journal.id }, as: :json

        expect(response).to have_http_status(:success)
        expect(assigns(:plant_journal)).to eq(plant_journal)
      end
    end

    context 'when journal is shared with user' do
      it 'returns the shared plant journal' do
        shared_journal = create(:plant_journal, user: other_user)
        create(:shared_journal, user: user, plant_journal: shared_journal)

        get :show, params: { id: shared_journal.id }, as: :json

        expect(response).to have_http_status(:success)
        expect(assigns(:plant_journal)).to eq(shared_journal)
      end
    end

    context 'when journal is not found or not accessible' do
      it 'returns not found status' do
        get :show, params: { id: 999 }, as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('Plant Journal not found')
      end
    end
  end

  describe 'POST #create' do
    let!(:valid_params) { { title: 'My Garden Journal', user_id: user.id, plant_ids:[plant.id] } }
    let(:plants) {create_list(:plant, 3, user: user)}
    let(:params) {valid_params.merge(plant_ids: plants.map(&:id))}
    let(:created_journal){PlantJournal.last}
    context 'with valid parameters' do
      it 'creates a new plant journal' do
        expect {
          post :create, params: valid_params, as: :json
        }.to change(PlantJournal, :count).by(1)

        expect(response).to have_http_status(:success)
        expect(PlantJournal.last.user).to eq(user)
      end

      it 'creates a journal with associated plants' do
        post :create, params: params, as: :json

        expect(response).to have_http_status(:created)
        pry

        expect(created_journal.plants).to match_array([plant])
        expect(created_journal.plants.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        allow_any_instance_of(PlantJournal).to receive(:save).and_return(false)

        post :create, params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #share_journal' do
    context 'when sharing with valid user' do
      it 'creates a shared journal entry' do
        params = { id: plant_journal.id, email: other_user.email }

        expect {
          post :share_journal, params: params
        }.to change(SharedJournal, :count).by(1)

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['message']).to include('successfully shared')
      end

      it 'prevents duplicate sharing' do
        create(:shared_journal, user: other_user, plant_journal: plant_journal)
        params = { id: plant_journal.id, email: other_user.email }

        post :share_journal, params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to include('already shared')
      end
    end

    context 'when sharing with invalid user' do
      it 'returns not found status' do
        post :share_journal, params: { id: plant_journal.id, email: 'nonexistent@example.com' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('User not found')
      end
    end
  end

  describe 'DELETE #destroy_plant' do
    let!(:journal_plant) { create(:plant, user: user) }

    before do
      plant_journal.plants << journal_plant
    end

    context 'with valid parameters' do
      it 'removes plant from journal' do
        expect {
          delete :destroy_plant, params: { plant_journal_id: plant_journal.id, id: journal_plant.id }
        }.to change { plant_journal.plants.count }.by(-1)

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['message']).to include('has been removed')
      end
    end

    context 'with invalid parameters' do
      it 'returns not found for invalid journal' do
        delete :destroy_plant, params: { plant_journal_id: 999, id: journal_plant.id }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('Plant or journal not found')
      end

      it 'returns unprocessable entity for plant not in journal' do
        other_plant = create(:plant, user: user)

        delete :destroy_plant, params: { plant_journal_id: plant_journal.id, id: other_plant.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Plant not found in this journal')
      end
    end
  end
end
