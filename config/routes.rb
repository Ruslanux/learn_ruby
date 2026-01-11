Rails.application.routes.draw do
  devise_for :users

  # Locale switching
  get "locale/:lang", to: "locale#switch", as: :switch_locale

  resources :lessons, only: [ :index, :show ] do
    resources :exercises, only: [ :show ] do
      member do
        post :run
        post :submit
      end
    end
  end

  get "leaderboard", to: "leaderboard#index"
  get "profile", to: "profile#show"

  # API v1
  namespace :api do
    namespace :v1 do
      # Authentication
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      post "auth/refresh", to: "auth#refresh"

      # Lessons
      resources :lessons, only: [:index, :show]

      # Exercises
      resources :exercises, only: [:show] do
        member do
          post :run
          post :submit
        end
      end

      # User
      get "users/me", to: "users#me"
      get "users/me/progress", to: "users#progress"
      get "users/me/achievements", to: "users#achievements"

      # Leaderboard
      get "leaderboard", to: "leaderboard#index"
      get "leaderboard/streaks", to: "leaderboard#streaks"
    end
  end

  # Admin Panel
  namespace :admin do
    root to: "dashboard#index"
    resources :lessons
    resources :exercises
    resources :submissions, only: [ :index, :show ]
    resources :users, only: [ :index, :show, :edit, :update ] do
      member do
        post :toggle_admin
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"

  # Error pages
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_error", via: :all
end
