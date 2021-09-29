require "localizable"
require "http_authenticable"

class ApplicationController < ActionController::Base
  include Localizable
  include HttpAuthenticable

  add_flash_types :success
  before_action :authenticate_user!
end
