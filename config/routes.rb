Rails.application.routes.draw do 
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # 编写路由
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :tokens, only: [:create]
      resources :shops, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :orders, only: [:index, :show, :create]
    end
  end
end
