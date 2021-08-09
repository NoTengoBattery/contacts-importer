require "rails_helper"

RSpec.describe "ContactLists", type: :request do
  before do
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe "GET /" do
    it "returns http success" do
      get "/contact_lists"
      expect(response).to have_http_status(:success)
    end
  end
end
