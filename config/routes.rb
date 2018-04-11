require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      get 'trending', to: 'trending#index'
      post 'user_token', to: 'user_token#create'
      get 'search', to: 'search#index'
      get 'autocomplete', to: 'search#autocomplete'
      get 'timeline', to: 'timeline#index'
      resources :tweets, only: %i[index show create update destroy] do
        member do
          post 'like', to: 'likes#create'
          delete 'like', to: 'likes#destroy'
        end
      end

      resources :users, only: %i[show create update destroy] do
        member do
          get 'following'
          get 'followers'
          post 'follow', to: 'follows#create'
          delete 'follow', to: 'follows#destroy'
        end
        get 'current', on: :collection
      end
    end
  end
end