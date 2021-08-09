class ContactListsController < ApplicationController
  before_action :set_contact_list, only: %i[show]

  def new
    @contact_list = current_user.contact_lists.build
  end

  def create
    @contact_list = current_user.contact_lists.build(contact_list_params)
    if @contact_list.save
      ExtractCsvJob.perform_later(resource: @contact_list)
      redirect_to @contact_list, notice: I18n.t("contact_lists.messages.successful_upload")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    true
  end

  def map
    true
  end

  private
    def contact_list_params
      params.fetch(ContactList.model_name.param_key.to_sym, {}).permit(:contacts_file)
    end

    def set_contact_list
      @contact_list = ContactList.find(params[:id])
    end
end
