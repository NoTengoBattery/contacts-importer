require "rails_helper"

# NOTE: Devise handles the email and password validations (no need to test them)

RSpec.describe User, type: :model do
  context "with validations" do
    subject { FactoryBot.build(:user) }

    pending "add some examples to (or delete) #{__FILE__}"
  end
end
