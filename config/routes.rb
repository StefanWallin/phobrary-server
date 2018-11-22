Rails.application.routes.draw do
  root to: 'app#app'
  resources :photos
end
