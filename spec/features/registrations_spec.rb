require "rails_helper"
require "shared_rutines"

# Due to time shortage I will copy-paste the code. Ideally, I would abstract the differences in a
# common example.

RSpec.describe "user registration page", type: :system do
  describe "sign up" do
    it "shows the 'Sign up' page" do
      visit new_user_registration_path
      expect(page).to have_content(I18n.t("users.registrations.new.sign_up"))
    end

    context "with valid user sign up" do
      subject(:user) { FactoryBot.build(:user) }

      it "allows a user to sing up" do
        visit new_user_registration_path
        fill_in I18n.t("activerecord.attributes.user.email"), with: user.email
        fill_in I18n.t("activerecord.attributes.user.password"), with: user.password
        fill_in I18n.t("activerecord.attributes.user.password_confirmation"), with: user.password
        click_button I18n.t("users.registrations.new.sign_up_btn")
        expect(page).to have_no_current_path(new_user_registration_path, ignore_query: true)
      end
    end

    context "with invvalid user sign up" do
      subject(:user) { FactoryBot.build(:user) }

      it "prevents a user from singing up" do
        visit new_user_registration_path
        fill_in I18n.t("activerecord.attributes.user.email"), with: user.email
        fill_in I18n.t("activerecord.attributes.user.password"), with: user.password
        fill_in I18n.t("activerecord.attributes.user.password_confirmation"), with: "#{user.password}+"
        click_button I18n.t("users.registrations.new.sign_up_btn")
        expect(page).to have_current_path(new_user_registration_path, ignore_query: true)
      end
    end
  end
end
