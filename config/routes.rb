Rails.application.routes.draw do
  devise_for :users
  get "/", to: "notes#index"
  
  resources :notes do
    resources :comments, shallow: true, except: [:new] 
  end
  
  namespace :api do
    namespace :v1 do
      resources :notes, only: [] do
        member do
          post :collection
        end
      end
    end
  end
end
