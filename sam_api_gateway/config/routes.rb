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

  #SendMail
  get 'sentmails', to: 'mail#sentMails'
  get 'sentmails/:id', to: 'mail#sentMail'
  delete 'sentmails/:id', to: 'mail#delSent'
  post 'sendmail', to: 'mail#sendMail'
  get 'senddrafts/:id', to: 'mail#send_drafts'

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

  #ReceivedMail
  delete 'ReceivedMails/:id', to: 'mail#delReceivedMail'
  get 'ReceivedMails', to: 'mail#received_mails'
  get 'ReceivedMails/:id', to: 'mail#received_mail'
  get 'inbox/sender/:sender', to: 'mail#bySender'
  get 'inbox/:filter', to: 'mail#by_filter'

end
