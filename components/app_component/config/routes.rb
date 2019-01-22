AppComponent::Engine.routes.draw do
  resources :games
  resources :teams

  resource :welcome, only: [:show]
  resource :prediction, only: [:new, :create]

  get 'welcome/index'
  root to: "welcome#index"
end
