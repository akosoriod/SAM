Rails.application.routes.draw do

  #Login
  get 'refreshtoken', to: 'sessions#refresh_token'
  post 'users/login', to: 'sessions#login'

  #Usuario
  get 'users/index', to: 'users#index_user'
  get 'users/show/:id', to: 'users#show_user'
  put 'users/update/:id', to: 'users#update_user'
  post 'users/create', to: 'users#create_user'
  delete 'users/destroy/:id', to: 'users#destroy_user'

end
