require "localizable"
require "http_authenticable"

class ApplicationController < ActionController::Base
  include Localizable
  include HttpAuthenticable

  before_action :authenticate_user!
end
