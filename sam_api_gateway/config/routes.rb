Rails.application.routes.draw do

  get 'refreshtoken', to: 'sessions#refresh_token'
  post 'users/login', to: 'sessions#login'

  #SendMail
  get 'sentmails', to: 'mail#sentMails'
  get 'sentmails/:id', to: 'mail#sentMail'
  delete 'sentmails/:id', to: 'mail#delSent'
  post 'sendmail', to: 'mail#sendMail'
  #filtered
  get 'dafts', to: 'mail#dafts'
  get 'dafts/:id', to: 'mail#dafts'
  delete 'dafts/:id', to: 'mail#delDaft'
  get 'senturgent', to: 'mail#urgent'
  get 'senturgent/:id', to: 'mail#urgent'
  delete 'senturgent/:id', to: 'mail#delSent'
  get 'daftsurgent', to: 'mail#daftAndUrgent'
  get 'daftsurgent/:id', to: 'mail#daftAndUrgent'
  delete 'daftsurgent/:id', to: 'mail#delDaft'


end
