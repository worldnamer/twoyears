Twoyears::Application.routes.draw do
  namespace :api do
    resources :commits, only: [:index] do
      resources :tags, only: [:update, :destroy] do
      end
      collection do
        get :tag_counts
        get :counts_by_day_as_rickshaw
        get :by_day
      end
    end
  end

  resources :commits, only: [:index]
  resources :tags, only: [:index]

  root :to => 'welcome#index'
end
