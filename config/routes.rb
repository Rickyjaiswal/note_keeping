Rails.application.routes.draw do

devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
root to: "notes#index"
  resources :notes do
    collection do
      post 'share' 
      post 'unshare'   
    end  
  end
end
