require "domain_routing"

Rails.application.routes.draw do
  devise_for :users

  # TODO: Remove this placeholders
  root "placeholders#index"
  patch "/locale/:locale", action: :site_locale, controller: :locales, as: :site_locale
  put "/locale", action: :default_locale, controller: :locales, as: :default_locale
end
