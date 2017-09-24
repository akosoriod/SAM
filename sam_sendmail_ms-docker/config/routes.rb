Rails.application.routes.draw do
  resources :sent_mails

  #filtered
  get 'dafts', to: 'sent_mails#dafts'
  get 'dafts/:id', to: 'sent_mails#dafts'
  delete 'dafts/:id', to: 'sent_mails#delDaft'
  get 'senturgent', to: 'sent_mails#urgent'
  get 'senturgent/:id', to: 'sent_mails#urgent'
  delete 'senturgent/:id', to: 'sent_mails#destroy'
  get 'daftsurgent', to: 'sent_mails#daftAndUrgent'
  get 'daftsurgent/:id', to: 'sent_mails#daftAndUrgent'
  delete 'daftsurgent/:id', to: 'sent_mails#delDaft'

end
