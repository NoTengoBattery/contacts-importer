require "domain_routing"

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]

  resources :contact_lists, only: %i[index new create show]
  patch "/contact_lists/map", "contact_lists#map"

  patch "/locale/:locale", action: :site_locale, controller: :locales, as: :site_locale
  put "/locale", action: :default_locale, controller: :locales, as: :default_locale

  root "contact_lists#index"
end
