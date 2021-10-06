class ContactErrorsController < ApplicationController
  def index
    @list_class = ContactList
    @contacts = current_user.contact_errors.order("created_at DESC").page(params[:page]).includes([:user, :contact_list])
  end
end
