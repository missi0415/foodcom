Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources   :users do
        member do
          put '/update_avatar'  , to: '/api/v1/users#update_avatar'
          get '/following_users', to: '/api/v1/users#following_users'
          get '/followers'      , to: '/api/v1/users#followers'
        end
      end
      resources   :relationships, only: %i[create destroy]
      resources   :posts        , only: %i[index show create update destroy] do
        member do 
          get '/commentcount'   ,  to: '/api/v1/posts#commentcount'
        end
      end
      resources   :like_posts   , only: %i[create destroy]
      resources   :notifications, only: %i[show create]
      get 'find_login_user/:uid'          => 'users#find_login_user'
      get 'search_likes'                  => 'users#search_likes'
      get 'post_comments'                 => 'posts#search_likes'
      get 'find_notifications_count/:id'  => 'notifications#find_notifications_count'
      get 'search',                       to: "searches#search"
    end
  end
end
