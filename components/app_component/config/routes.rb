AppComponent::Engine.routes.draw do
  resources :games
  resources :teams
  get 'welcome/index'
  root to: "welcome#index"
end
