Twoyears::Application.routes.draw do
  namespace :api do
    resources :commits, only: [:index] do
      resources :tags, only: [:update]
    end
  end

  resources :commits, only: [:index]

  root :to => 'welcome#index'
end
