Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  resources :licenses
  resources :sps
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :homes
  root to: "homes#index"

end
