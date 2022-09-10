Rails.application.routes.draw do

  root to: "homes#top"
  get "home/about"=>"homes#about"

  namespace :public do
    resources :users, only: [:show, :edit, :update]
    resources :play_lists, only: [:new, :create, :show, :edit, :update, :destroy]
    resources :tracks, only: [:new, :index, :show, :edit, :create, :destroy, :update]do
      resources :comments, only: [:create, :destroy]
      resource :track_favorites, only: [:create, :destroy]
    end
    resources :track_favorites, only: [:index]
    resources :artists, only: [:show]
    get "searches/tags"=>"searches#search_tag"
    get "searches/keywords"=>"searches#search_keyword"
  end

  namespace :admin do
    resources :users, only: [:index, :show, :destroy]
    resources :tracks, only: [:destroy]do
     resources :comments, only: [:index, :destroy]
    end
  end


  devise_for :users,skip: [:passwords], controllers:  {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
