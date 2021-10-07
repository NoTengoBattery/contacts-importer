require "rails_helper"

RSpec.describe "Contact list", type: :request do
  subject(:contact_list) { FactoryBot.attributes_for(:contact_list) }

  before do
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe "when submitting a CSV file" do
    it "shows a form to submit a new list" do
      get "/contact_lists/new"
      expect(response).to render_template(:new)
    end

    it "accepts a CSV file" do
      post "/contact_lists", params: {contact_list: contact_list}
      expect(response).to redirect_to(assigns(:contact_list))
    end
  end

  describe "when needing mappings" do
    it "shows a form to map the CSV details" do
      post "/contact_lists", params: {contact_list: contact_list}
      perform_enqueued_jobs
      get contact_list_path(assigns(:contact_list))
      expect(response).to render_template("contact_lists/_mappings")
    end
  end

  describe "with successful records" do
    let(:contact_list_good) { FactoryBot.create(:contact_list) }

    it "show a paginated index" do
      get contact_lists_path
      expect(response).to render_template("shared/_pagination")
    end
  end
end
