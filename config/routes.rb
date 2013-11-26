Twoyears::Application.routes.draw do
  namespace :api do
    resources :commits, only: [:index] do
      resources :tags, only: [:update, :destroy] do
      end
      collection do
        get :counts_by_day_as_rickshaw
        get :by_day
        get :by_week
      end
    end

    resources :tags, only: [:index] do
      member do
        get :by_day_of_week
      end
    end

    match 'github_commit_hook', to: 'github_commit_hook#hook', via: [:post]
  end

  resources :commits, only: [:index]
  resources :tags, only: [:index]

  root :to => 'welcome#index'
end
