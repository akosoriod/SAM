Rails.application.routes.draw do
  get 'refresh/profile', to: 'sessions#refresh_token'
end
