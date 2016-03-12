Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  # resources :users
  resources :sessions
  resources :snipes do
    member do
      get 'force_bid'
    end
  end

  namespace :admin do
    resources :ebay_items
    root to: 'ebay_items#index'
  end

  root to: 'snipes#index'
end
