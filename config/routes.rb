Rails.application.routes.draw do
  namespace :admin do
    resources :rooms
    resources :acounts do
      resources :results, except: :index
      resources :test_results, except: :index
      resources :special_points, except: :index
    end
    resources :room_requests
    resources :products
    resources :product_requests
    resources :deliveries
    resources :curriculums
    resources :room_users
  end
  get 'admin/acount/:id/edit_profile',  to: 'admin/acounts#edit_profile',    as: 'edit_profile_admin_acount'
  get 'admin/acount/:id/authentication', to: 'admin/acounts#authentication', as: 'authentication_admin_acount'
  get 'admin/acount/:id/destroy_modal', to: 'admin/acounts#destroy_modal',   as: 'destroy_modal_admin_acount'
  get 'admin/acount/:id/authentication_question',
      to: 'admin/acounts#authentication_question',
      as: 'authentication_question_admin_acount'

  post 'admin/acount/:id/edit_password', to: 'admin/acounts#edit_password', as: 'edit_password_admin_acount'
  post 'admin/acount/:id/edit_question', to: 'admin/acounts#edit_question', as: 'edit_question_admin_acount'

  patch 'admin/acount/:id/update_password', to: 'admin/acounts#update_password', as: 'update_password_admin_acount'
  patch 'admin/acount/:id/update_question', to: 'admin/acounts#update_question', as: 'update_question_admin_acount'

  get 'admin/room/:id/edit_name', to: 'admin/rooms#edit_name', as: 'edit_name_admin_room'

  patch 'admin/room/:id/update_name', to: 'admin/rooms#update_name', as: 'update_name_admin_room'

  get 'admin/product/:id/edit/destroy_modal', to: 'admin/products#destroy_modal', as: 'destroy_modal_admin_product'

  patch 'admin/product/:id/edit/set_deleted', to: 'admin/products#set_deleted', as: 'set_deleted_admin_product'

  get 'admin/curriculum/:id/edit/destroy_modal', to: 'admin/curriculums#destroy_modal', as: 'destroy_modal_admin_curriculum'

  patch 'admin/curriculum/:id/edit/set_deleted', to: 'admin/curriculums#set_deleted', as: 'set_deleted_admin_curriculum'

  get 'admin/result/index', to: 'admin/results#index', as: 'admin_results'
  get 'admin/result/new/create_modal', to: 'admin/results#create_modal', as: 'create_modal_admin_result'

  get 'admin/test_result/new/create_modal', to: 'admin/test_results#create_modal', as: 'create_modal_admin_test_result'
  get 'admin/test_result/new/index', to: 'admin/test_results#index', as: 'admin_test_results'

  get 'admin/special_points/new/create_modal', to: 'admin/special_points#create_modal', as: 'create_modal_admin_special_point'
  get 'admin/special_points/new/index', to: 'admin/special_points#index', as: 'admin_special_points'

  post 'admin/room_request/:id/create', to: 'admin/room_requests#create', as: 'admin_room_request_create'

  get 'admin/room_user/:id/destroy_modal', to: 'admin/room_users#destroy_modal', as: 'admin_room_user_destroy_modal'

  get 'products/:id/index',   to: 'products#index',  as: 'products'
  get 'products/:id/buy',     to: 'products#buy',    as: 'product_buy'
  get 'products/:id/request', to: 'product#request', as: 'product_request'
  get 'products/:id/history', to: 'product#history', as: 'product_history'

  resources :room_requests, only: [:new, :create]
  get 'room_request/new/create_modal', to: 'room_requests#create_modal', as: 'create_modal_room_request'
  resources :acounts
  get 'acounts/new/nomal_new', to: 'acounts#nomal_new', as: 'nomal_new'

  get  '/logout', to: 'sessions#logout'
  get  '/login',  to: 'sessions#login'
  post '/login',  to: 'sessions#create'

  root to: 'sessions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
