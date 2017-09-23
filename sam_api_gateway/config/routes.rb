Rails.application.routes.draw do

  get 'refreshtoken', to: 'sessions#refresh_token'
  post 'users/login', to: 'sessions#login'

end
