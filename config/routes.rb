Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[show]

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "rooms#index"
  resources :users, only: %i[show]
  resources :rooms do
    resources :messages
  end
end
