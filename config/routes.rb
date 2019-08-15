Rails.application.routes.draw do
  namespace :admin do
    resources :groups
  end

  namespace :admin do
    resources :acounts
  end

  namespace :admin do
    resources :products
  end

  get 'products/:id/index',   to: 'products#index',  as: 'products'
  get 'products/:id/buy',     to: 'products#buy',    as: 'product_buy'
  get 'products/:id/request', to: 'product#request', as: 'product_request'
  get 'products/:id/history', to: 'product#history', as: 'product_history'

  resources :acounts
  get 'acounts/new/nomal_new', to: 'acounts#nomal_new', as: 'nomal_new'

  get '/logout', to: 'sessions#logout'
  get '/login',  to: 'sessions#login'
  post '/login', to: 'sessions#create'
  
  root to: 'sessions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
