Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources   :users do
        member do
          put '/update_avatar', to: '/api/v1/users#update_avatar'
          get '/following', to: '/api/v1/users#following'
          get '/followers', to: '/api/v1/users#followers'
        end
      end
      resources   :relationships, only: %i[create destroy]
      resources   :posts        , only: %i[index show create update destroy]
      resources   :comments     , only: %i[show create update destroy]
      resources   :like_posts   , only: %i[create destroy]
      resources   :like_comments, only: %i[create destroy]
      # user
      get 'find_login_user/:uid'  => 'users#find_login_user'
      get 'search_likes'          => 'users#search_likes'
      # comment
      get 'search_comments/:id'   => 'comments#search_comments'
    end
  end
end
