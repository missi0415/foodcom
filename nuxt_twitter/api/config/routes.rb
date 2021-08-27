Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources   :users do
        resource :relationships, only: [:create, :destroy]
        get 'followings' => 'relationships#followings', as: 'followings'
        get 'followers'  => 'relationships#followers' , as: 'followers'
      end
      resources   :posts        , only: %i[index show create update destroy]
      resources   :comments     , only: %i[show create update destroy]
      resources   :like_posts   , only: %i[create destroy]
      resources   :like_comments, only: %i[create destroy]
      # user
      get 'find_login_user/:uid'  => 'users#find_login_user'
      # comment
      get 'search_comments/:id'   => 'comments#search_comments'
    end
  end
end
