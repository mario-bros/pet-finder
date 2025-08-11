Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#restricted_access', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  root 'static_pages#home'
  get '/terms_and_conditions', to: 'static_pages#terms_and_conditions'
  get '/cookie_policy', to: 'static_pages#cookie_policy'

  get '/contacts', to: 'contacts#create'
  get '/contacts/new', to: 'contacts#new', as: 'new_contact'

  get '/adoptable_dogs', to: 'adoptable_dogs#index'
  get '/adoptable_dogs/:id', to: 'adoptable_dogs#show', as: 'adoptable_dog'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }

  # Add this catch-all route at the very end
  match '*path', to: 'errors#not_found', via: :all
end
