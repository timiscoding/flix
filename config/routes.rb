Rails.application.routes.draw do
  resources :genres
  resources :users
  root 'movies#index'
  get 'movies/filter/:filter' => 'movies#index', as: :filtered_movies

  resources :movies do
    resources :favorites, only: [:create, :destroy]
    resources :reviews
  end

  get 'signup' => 'users#new'

  resource :session, only: [:new, :create, :destroy]
  get 'signin' => 'sessions#new'

end
