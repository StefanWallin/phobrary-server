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
    namespace :files do
      namespace :v1 do
        # Implements the tus.io file upload protocol with version 1.0.0:
        # https://github.com/tus/tus-resumable-upload-protocol
        match '/', to: 'files#options', via: :options # Core protocol
        match '/:slug', to: 'files#status', via: :head # Core protocol
        match '/:slug', to: 'files#update', via: :patch # Core protocol
        match '/', to: 'files#create', via: :post # Implements the 'creation' extension
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
