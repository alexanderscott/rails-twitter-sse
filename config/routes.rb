TwitterSocketStreaming::Application.routes.draw do

  # Auth routes
  match "auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "auth/failure", to: "sessions#failure", via: [:get, :post]
  match "signout", to: "sessions#destroy", via: [:get, :post]

  # Stream routes
  get "socket", to: "sockets#connect"

  get "tweets/get_tpl", to: "tweets#get_tpl"
  post "tweets/create", to: "tweets#create"

  resources :tweets

  # Page routes
  root "users#index"

end
