Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: %w(create show) do
      end

      devise_scope :user do
        post 'sessions', to: 'sessions#create'
        delete 'sessions', to: 'sessions#destroy'
      end

      namespace :admin do
        resources :chapters, only: [:index, :create]
      end
    end
  end
end
