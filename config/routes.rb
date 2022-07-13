Rails.application.routes.draw do
  namespace :public do
    resources :users, only: [:index, :show, :edit]
    resources :tracks, only: [:index, :show, :edit, :create, :destroy, :update]do
      resources :comments, only: [:create, :destroy]
      resource :track_favorites, only: [:create, :destroy]
    end
    
    resources :track_favorites, only: [:index]
    
    get "searches/tags"=>"searches#search_tag"
    get "searches/keywords"=>"searches#search_keyword"
  end

  root to: "homes#top"
  get "home/about"=>"homes#about"
  devise_for :users,controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
