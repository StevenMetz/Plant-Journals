Rails.application.routes.draw do
  post 'plant_journal/share_journal/:id', to:'plant_journals#share_journal', as: 'share_journal'
  resources :plant_journals do
    delete 'plants/:id', to: 'plant_journals#destroy_plant', as: 'destroy_plant'
  end
  resources :plants
  devise_for :users, skip: :all
  devise_scope :user do
    get 'user/profile' => "users/profile#show"
    delete 'logout' => "users/sessions#destroy"
    post 'login' => "users/sessions#create"
    post 'signup' => 'users/registrations#create'
    delete 'delete_account/:id' => 'users/registrations#destroy'
    patch 'user/:id' => 'users/registrations#update_user'
    delete 'user/:id/delete' => 'users/registrations#delete_user'
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
