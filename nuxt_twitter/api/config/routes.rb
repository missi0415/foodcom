Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      get 'find_login_user/:uid' => 'users#find_login_user'
      resources :posts, only: %i[index show create update destroy]
      resources :comments
    end
  end
end
