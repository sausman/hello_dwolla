Rails.application.routes.draw do
  root 'welcome#index'
  get '/auth', to: 'auth#new', as: :login
  get '/auth/callback', to: 'auth#callback', as: :callback
  delete '/auth', to: 'auth#destroy', as: :logout
end
