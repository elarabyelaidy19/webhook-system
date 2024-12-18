Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "/webhooks", to: proc { [ 204, {}, [] ] }
  resources :webhook_events, only: [ :create ]
  post "auth/login", to: "authentication#login"
  post "auth/signup", to: "authentication#signup"
  resources :webhooks, only: [ :index, :show, :create, :update, :destroy ]
end
