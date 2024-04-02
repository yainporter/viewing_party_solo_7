Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "welcome#index"
  get '/register', to: 'users#new', as: 'register_user'

  resources :users, only: %i[show create] do
    resources :discover, only: :index
    resources :movies, only: %i[index show] do
      resources :viewing_party, only: %i[new create show]
    end
  end
  get "/users/:user_id/movies/:movie_id/similar", to: "similar#index", as: :similar_movies

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
