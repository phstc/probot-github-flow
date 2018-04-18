Rails.application.routes.draw do
  get '/login' => 'sessions#index'
  get '/callback' => 'sessions#callback'

  post '/webhook' => 'webhooks#create'

  resources :repositories, only: :create

  root to: 'home#index'
end
