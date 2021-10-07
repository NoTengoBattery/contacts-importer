require "domain_routing"

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]

  resources :contact_lists, only: %i[index new create show]
  patch "/contact_lists/map/:id", action: :map, controller: :contact_lists, as: :contact_lists_map
  resources :contacts, only: %i[index]
  resources :contact_errors, only: %i[index]

  patch "/locale/:locale", action: :site_locale, controller: :locales, as: :site_locale
  put "/locale", action: :default_locale, controller: :locales, as: :default_locale

  root "contact_lists#index"
end
