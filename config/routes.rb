Rails.application.routes.draw do
  root 'products#index'
  resources :products

  namespace :api, { format: 'json' } do
    namespace :v1 do
      # resources :products, only: [:index, :show, :update, :destroy]
      get 'auth' => 'products#auth'
      get 'unauth' => 'products#unauth'
      get 'show' => 'products#show'
      get 'destroy' => 'products#destroy'
      get 'update' => 'products#update'
      get 'index' => 'products#index'
    end
  end
end
