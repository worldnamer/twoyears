Twoyears::Application.routes.draw do
  namespace :api do
    resources :commits, only: [:index] do
      resources :tags, only: [:update, :destroy] do
      end
      collection do
        get :tag_counts
        get :counts_by_day_as_rickshaw
      end
    end
  end

  resources :commits, only: [:index]

  root :to => 'welcome#index'
end
