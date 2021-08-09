require "rails_helper"
require "shared_rutines"

# Due to time shortage I will copy-paste the code. Ideally, I would abstract the differences in a
# common example.

RSpec.describe "user session page", type: :system do
  describe "sign in" do
    it "shows the 'Sign in' page" do
      visit new_user_session_path
      expect(page).to have_content(I18n.t("users.sessions.new.sign_in"))
    end

    context "with valid user sign in" do
      subject(:user) { FactoryBot.create(:user) }

      it "allows a user to sing in" do
        visit new_user_session_path
        fill_in I18n.t("activerecord.attributes.user.email"), with: user.email
        fill_in I18n.t("activerecord.attributes.user.password"), with: user.password
        click_button I18n.t("users.sessions.new.sign_in_btn")
        expect(page).to have_current_path(new_user_session_path, ignore_query: true)
      end
    end

    context "with invalid user sign in" do
      subject(:user) { FactoryBot.create(:user) }

      it "prevents a user from singin in" do
        visit new_user_session_path
        fill_in I18n.t("activerecord.attributes.user.email"), with: user.email
        fill_in I18n.t("activerecord.attributes.user.password"), with: "#{user.password}+"
        click_button I18n.t("users.sessions.new.sign_in_btn")
        expect(page).to have_current_path(new_user_session_path, ignore_query: true)
      end
    end
  end
end
