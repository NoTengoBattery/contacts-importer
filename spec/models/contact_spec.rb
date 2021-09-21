require "rails_helper"
require "shared_rutines"

RSpec.describe Contact, type: :model do
  context "with validations" do
    subject(:contact) { FactoryBot.build(:contact) }

    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:credit_card) }
  end
end
