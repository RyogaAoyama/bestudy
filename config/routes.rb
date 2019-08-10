Rails.application.routes.draw do


  resources :acounts
  get 'acounts/new/nomal_new', to: 'acounts#nomal_new', as: 'nomal_new'
  get 'acounts/new/admin_new', to: 'acounts#admin_new', as: 'admin_new'
  get '/login', to: 'sessions#login'
  root to: 'sessions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
