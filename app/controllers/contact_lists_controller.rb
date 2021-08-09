class ContactListsController < ApplicationController
  before_action :set_contact_list, only: %i[show map]

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

  # No time to optimize this
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def map
    user_map = params.fetch(:map, {})
    @contact_list.ir["headers"] = user_map
    if user_map.values.any?(&:empty?)
      flash.now[:notice] = I18n.t("contact_lists.messages.blank")
      render :show, status: :unprocessable_entity
    elsif user_map.values.uniq.length != user_map.values.length
      flash.now[:notice] = I18n.t("contact_lists.messages.unique")
      render :show, status: :unprocessable_entity
    else
      @contact_list.status = :mapped
      if @contact_list.save
        ExtractCsvJob.perform_later(resource: @contact_list)
        redirect_to @contact_list, notice: I18n.t("contact_lists.messages.successful_map")
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private
    def contact_list_params
      params.fetch(ContactList.model_name.param_key.to_sym, {}).permit(:contacts_file)
    end

    def set_contact_list
      @contact_list = ContactList.find(params[:id])
    end
end
