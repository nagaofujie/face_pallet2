Rails.application.routes.draw do


devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
end

devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  
  
scope module: :public do
   get 'homes/top'
    get "/customers/withdraw" => "customers#withdraw"
  resources :customers, only: [:show, :edit, :update] do
    get :favorites, on: :collection
  end
    get "search_tag"=>"posts#search_tag"
    resources :posts do
      resources :favorites, only: [:create, :destroy]
      resources :comments, only: [:create]
  end
end



namespace :admin do
  get 'homes/top'
  resources :customers
  resources :posts
  resources :favorites
  resources :comments
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
