Rails.application.routes.draw do
  resources :taryphs
  devise_for :users, :path => 'users'
  resources :users, shallow: true do
   resources :licenses
  end
  resources :sps
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'homes/index'
  root to: "homes#index"
  post 'users/change_pic'
  post 'users/create_pre_order'
  post 'users/create_pre_order_ajax', format: "js" #, :defaults => { :format => :json }
end
