require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:notification) { create(:notification, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    let!(:old_notification) { create(:notification, user: user, created_at: 2.days.ago) }
    let!(:new_notification) { create(:notification, user: user, created_at: 1.day.ago) }
    let!(:other_user_notification) { create(:notification, user: other_user) }

    it 'returns all notifications in descending order' do
      get :index, as: :json
      expect(response).to have_http_status(:ok)
      expect(assigns(:notifications)).to eq(Notification.order(created_at: :desc))
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user_id: user.id,
          title: 'Test Notification',
          message: 'This is a test notification',
          notification_type: 0,
          viewed: false
        }
      end

      it 'creates a new notification' do
        expect {
          post :create, params: valid_params, as: :json
        }.to change(Notification, :count).by(1)
      end

      it 'returns created status' do
        post :create, params: valid_params, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'creates notification with correct attributes' do
        post :create, params: valid_params, as: :json
        created_notification = Notification.last
        expect(created_notification.title).to eq('Test Notification')
        expect(created_notification.message).to eq('This is a test notification')
        expect(created_notification.notification_type).to eq("alert")
        expect(created_notification.viewed).to be false
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user_id: user.id } } # Missing required title and message

      it 'raises RecordInvalid error' do
        expect {
          post :create, params: invalid_params, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with missing user_id' do
      let(:invalid_params) do
        {
          title: 'Test',
          message: 'Test message'
        }
      end

      it 'raises RecordInvalid error' do
        expect {
          post :create, params: invalid_params, as: :json
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:update_params) do
        {
          id: notification.id,
          title: 'Updated Title',
          message: 'Updated message',
          viewed: true
        }
      end

      it 'updates the notification' do
        patch :update, params: update_params, as: :json
        notification.reload
        expect(notification.title).to eq('Updated Title')
        expect(notification.message).to eq('Updated message')
        expect(notification.viewed).to be true
      end

      it 'returns success status and updated notifications' do
        patch :update, params: update_params, as: :json
        expect(response).to have_http_status(:success)
        expect(assigns(:notifications)).to eq(Notification.order(created_at: :desc))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          id: notification.id,
          title: '',  # title can't be blank
          message: '' # message can't be blank
        }
      end

      it 'does not update the notification' do
        patch :update, params: invalid_update_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Unable to update notification')
      end
    end

    context 'with non-existent notification' do
      it 'returns not found status' do
        patch :update, params: { id: 999999, title: 'New Title' }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('Notification not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with existing notification' do
      it 'deletes the notification' do
        expect {
          delete :destroy, params: { id: notification.id }, as: :json
        }.to change(Notification, :count).by(-1)
      end

      it 'returns success status' do
        delete :destroy, params: { id: notification.id }, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Notification Removed')
      end
    end

    context 'with non-existent notification' do
      it 'returns unprocessable_entity status' do
        delete :destroy, params: { id: 999999 }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Unable to delete notification: Notification not found')
      end
    end

    context 'when deletion fails' do
      before do
        allow_any_instance_of(Notification).to receive(:destroy).and_return(false)
      end

      it 'returns unprocessable_entity status' do
        delete :destroy, params: { id: notification.id }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Unable to delete notification')
      end
    end
  end
end
