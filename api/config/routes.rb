Rails.application.routes.draw do

  resources :authors

  resources :articles do
    resources :comments
  end
end
