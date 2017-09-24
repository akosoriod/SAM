Rails.application.routes.draw do

  get 'refreshtoken', to: 'sessions#refresh_token'
  post 'users/login', to: 'sessions#login'

  #SendMail
  get 'sentmails', to: 'mail#sentMails'
  get 'sentmails/:id', to: 'mail#sentMail'
  delete 'sentmails/:id', to: 'mail#delSent'
  post 'sendmail', to: 'mail#sendMail'
  #filtered
  get 'drafts', to: 'mail#drafts'
  get 'drafts/:id', to: 'mail#drafts'
  put 'drafts/:id', to: 'mail#modifyDraft'
  delete 'drafts/:id', to: 'mail#delDraft'
  get 'senturgent', to: 'mail#urgent'
  get 'senturgent/:id', to: 'mail#urgent'
  delete 'senturgent/:id', to: 'mail#delSent'
  get 'draftsurgent', to: 'mail#draftAndUrgent'
  get 'draftsurgent/:id', to: 'mail#draftAndUrgent'
  delete 'draftsurgent/:id', to: 'mail#delDraft'

end
