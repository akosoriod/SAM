Rails.application.routes.draw do

  get 'refreshtoken', to: 'sessions#refresh_token'
  post 'users/login', to: 'sessions#login'

  #SendMail
  get 'sentMails', to: 'mail#sentMails'
  get 'sentMail', to: 'mail#sentMail'
  post 'sendMail', to: 'mail#sendMail'
  
end
