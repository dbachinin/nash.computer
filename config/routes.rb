Rails.application.routes.draw do
  resources :taryphs
  get 'download' => 'download#download' 
  devise_for :users, :path => 'users'
    resources :users, shallow: true do
    resources :licenses, param: :name do
      # get :show, on: :member
      # get :download, on: :member
      post :create, on: :member
      post :update, on: :member
    end
  end
  resources :sps
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'homes/index'
  root to: "homes#index"
  post 'users/change_pic'
  post 'users/create_pre_order'
  post 'users/create_pre_order_ajax', format: "js" #, :defaults => { :format => :json }
end
