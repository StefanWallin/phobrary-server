Rails.application.routes.draw do
  root to: 'photos#index'
  resources :photos
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :sessions do
      namespace :v1 do
        post '/' => 'sessions#create'
      end
    end
  end

end
