class ContactListsController < ApplicationController
  def new
    @contact_list = current_user.contact_lists.build
  end

  def create
    @contact_list = current_user.contact_lists.build(contact_list_params)
    if @contact_list.save
      redirect_to @contact_list, notice: I18n.t("contact_lists.messages.successful_upload")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def contact_list_params
      params.fetch(ContactList.model_name.param_key.to_sym, {}).permit(:contacts_file)
    end
end
