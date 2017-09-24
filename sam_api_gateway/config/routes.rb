Rails.application.routes.draw do

  get 'refreshtoken', to: 'sessions#refresh_token'
  post 'users/login', to: 'sessions#login'
  get 'users/index', to: 'users#index_user'
  get 'users/show', to: 'users#show_user'
  post 'users/update', to: 'users#update_user'
  post 'users/create', to: 'users#create_user'
  delete 'users/destroy', to: 'users#destroy_user'

end
