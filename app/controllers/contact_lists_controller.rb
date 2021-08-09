class ContactListsController < ApplicationController
  def new
    @contact_list = ContactList.new
  end
end
