class ContactsController < ApplicationController
  def index
    @list_class = ContactList
    @contacts = current_user.contacts.order("created_at DESC").page(params[:page])
  end
end
