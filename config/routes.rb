Rails.application.routes.draw do
  root to: 'orders#index'
  get 'widgets' => 'widgets#list_widgets'
  resources :orders, only: [:index, :show, :new, :create]
end
