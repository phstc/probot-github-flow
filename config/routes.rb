Rails.application.routes.draw do
  get '/login' => 'sessions#index'
  get '/callback' => 'sessions#callback'

  root to: 'home#index'
end
