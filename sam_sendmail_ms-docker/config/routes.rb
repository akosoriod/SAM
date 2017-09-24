Rails.application.routes.draw do
  resources :sent_mails

  #filtered
  get 'drafts', to: 'sent_mails#drafts'
  get 'drafts/:id', to: 'sent_mails#drafts'
  put 'drafts/:id', to: 'sent_mails#modifyDraft'
  delete 'drafts/:id', to: 'sent_mails#delDraft'
  get 'senturgent', to: 'sent_mails#urgent'
  get 'senturgent/:id', to: 'sent_mails#urgent'
  delete 'senturgent/:id', to: 'sent_mails#destroy'
  get 'draftsurgent', to: 'sent_mails#draftAndUrgent'
  get 'draftsurgent/:id', to: 'sent_mails#draftAndUrgent'
  delete 'draftsurgent/:id', to: 'sent_mails#delDraft'

end
