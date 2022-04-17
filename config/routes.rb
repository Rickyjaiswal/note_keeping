Rails.application.routes.draw do
  get 'share_note/index'
  post 'share_note/shared'
  resources :notes do
    collection do
      post 'share' 
      post 'unshare'   
    end  
  end

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
root to: "notes#index"
end
