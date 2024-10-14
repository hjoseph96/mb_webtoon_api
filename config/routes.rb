Rails.application.routes.draw do
  apipie
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "hello#index"

  namespace :api do
    namespace :v1 do

      resources :users, only: %w(create show update) do
      end

      resources :comments, only: %w(create show) do
        member do
          post :vote
        end
      end

      resources :chapters, only: %w(index show) do
        member do
          post :vote
        end
      end

      resources :patreon, only: :create


      resources :sessions, only: %w(create destroy)

      namespace :admin do
        resources :users, only: %w(index)
        resources :comments, only: %w(destroy)
        resources :chapters, only: %w(index create)
      end
    end
  end
end
