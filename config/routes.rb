Rails.application.routes.draw do
  root to: 'orders#index'
  resources :orders, only: [:index, :show, :new, :create]
end
