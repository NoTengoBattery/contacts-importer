require "rails_helper"
require "shared_rutines"

RSpec.describe ContactListsController, active_job: true, type: :controller do
  let(:contact_list_attributes) { FactoryBot.attributes_for(:contact_list) }

  before do
    user = FactoryBot.create(:user)
    controller.sign_in(user)
  end

  describe "#create" do
    it "stores a new contact list in the dabatase" do
      expect {
        post :create, params: {contact_list: contact_list_attributes}
      }.to change(ContactList, :count)
    end

    it "schedules a background job" do
      expect {
        post :create, params: {contact_list: contact_list_attributes}
      }.to have_enqueued_job(ExtractCsvJob)
    end
  end

  describe "#map" do
    let(:map) {
      {"Name" => "name",
       "Email" => "email",
       "Phone" => "phone",
       "Address" => "address",
       "Credit Card" => "credit_card",
       "Date of Birth" => "birth_date"}
    }

    it "updates a record with the supplied map" do
      list = FactoryBot.create(:contact_list)
      ExtractCsvJob.perform_now(resource: list)
      post :map, params: {id: list.id, map: map}
    end
  end
end
