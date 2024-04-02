Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "welcome#index"
  get '/register', to: 'users#new', as: 'register_user'

  resources :users, only: %i[show create] do
    resources :discover, only: [:destroy]
  end

  get "/movies/:movie_id/similar", to: "similar#index", as: :similar_movies

  resources :movies, only: [:index, :show] do
    resources :viewing_party, only: [:new, :create, :show]
  end
  resources :discover, only: :index

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
