Rails.application.routes.draw do
  devise_for :users

  get "user_posts", controller: :posts, as: :user_posts

  resources :posts do
    resources :comments
  end

  root "posts#index"
end
