Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  devise_for :users, controllers: { registrations: "users/registrations", passwords: "users/passwords", sessions: "users/sessions", confirmations: "users/confirmations" }
  resources :products
  get "products/categories/:id", to: "products#show_by_category", as: "products_in_category"
  resources :categories, except: [ :show ]
  root "pages#home"
  get "about_us", to: "pages#about"
  get "terms", to: "pages#terms"
  get "privacy_policy", to: "pages#privacy_policy"
  resources :pages, only: [ :edit, :update ]
  post "tinymce_assets", to: "tinymce_assets#create"
  resources :contact_forms, only: [ :new, :create ]
  post "add_to_cart/:id", to: "cart#add_to_cart", as: "add_to_cart"
  patch "update_cart_quantity", to: "cart#update_quantity"
  delete "remove_from_cart/:id", to: "cart#remove_from_cart", as: "remove_from_cart"
  delete "remove_all_from_cart", to: "cart#remove_all_from_cart"
  resources :cart, only: [ :index ]
  post "checkout", to: "checkout#index"
  post "checkout/address", to: "checkout#create", as: "checkout_address"
  #
end
