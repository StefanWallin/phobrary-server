Rails.application.routes.draw do
  root to: 'photos#index'
  resources :photos
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :sessions, only: :create
    end
  end

end
