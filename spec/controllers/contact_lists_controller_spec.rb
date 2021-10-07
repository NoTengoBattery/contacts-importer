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

    it "enqueues a background job" do
      expect {
        post :create, params: {contact_list: contact_list_attributes}
      }.to have_enqueued_job(ExtractCsvJob)
    end

    context "with invalid parameters" do
      it "responds with an error if the file type is invalid" do
        contact_list_attributes[:contacts_file].content_type = "text/txt"
        post :create, params: {contact_list: contact_list_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with an error if the params are not present" do
        post :create
        expect(response).to have_http_status(:unprocessable_entity)
      end
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
    let(:record) { FactoryBot.create(:contact_list) }

    def post_map
      ExtractCsvJob.perform_now(resource: record)
      post :map, params: {id: record.id, map: map}
    end

    it "changes the status of the list to :mapped" do
      post_map
      expect(record.reload).to be_mapped
    end

    it "enqueues a background job" do
      expect { post_map }.to have_enqueued_job(ExtractCsvJob)
    end

    context "with duplicated parameters" do
      let(:map) {
        {"Name" => "name",
         "Email" => "name",
         "Phone" => "phone",
         "Address" => "address",
         "Credit Card" => "credit_card",
         "Date of Birth" => "birth_date"}
      }

      it "respond with an error" do
        post_map
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not enqueue a background job" do
        expect { post_map }.not_to have_enqueued_job(ExtractCsvJob)
      end
    end

    context "with missing parameters" do
      let(:map) { {"Name" => "name"} }

      it "respond with an error" do
        post_map
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not enqueue a background job" do
        expect { post_map }.not_to have_enqueued_job(ExtractCsvJob)
      end
    end

    context "with no parameters" do
      let(:map) { {} }

      it "respond with an error" do
        post_map
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not enqueue a background job" do
        expect { post_map }.not_to have_enqueued_job(ExtractCsvJob)
      end
    end
  end
end
