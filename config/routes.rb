Twoyears::Application.routes.draw do
  namespace :api do
    resources :commits, only: [:index]
  end

  resources :commits, only: [:index]

  root :to => 'welcome#index'
end
