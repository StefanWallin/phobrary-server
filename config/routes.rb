# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'photos#index'
  resources :photos
  mount ActionCable.server => '/cable'

  namespace :api, defaults: { format: :json } do
    namespace :sessions do
      namespace :v1 do
        post '/' => 'sessions#create'
      end
    end
    namespace :photos do
      namespace :v1 do
        post '/' => 'photos#create'
      end
    end
    namespace :status do
      namespace :v1 do
        get '/' => 'status#index'
      end
    end
  end
end
