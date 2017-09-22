Rails.application.routes.draw do
  resources :received_mails
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/inbox/sender/:sender', to: 'received_mails#by_sender'
  get '/inbox/read/', to: 'received_mails#read'
  get '/inbox/unread/', to: 'received_mails#unread'
  get '/inbox/urgent/', to: 'received_mails#urgent'
  get '/inbox/not_urgent/', to: 'received_mails#not_urgent'
end
