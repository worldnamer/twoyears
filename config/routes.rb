Twoyears::Application.routes.draw do
  namespace :api do
    resources :commits, only: [:index]
  end

  root :to => 'welcome#index'
end
