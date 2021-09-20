require "rails_helper"
require "shared_rutines"

# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe Contact, type: :model do
  context "with validations" do
    subject(:contact) { FactoryBot.build(:contact) }

    it { is_expected.to validate_presence_of(:address) }

    # rubocop:disable RSpec/MultipleExpectations
    it { is_expected.to validate_presence_of(:birth_date) }

    it "is expected to validate that :birth_date is ISO8601" do
      contact.birth_date = "01 Jan 1970"
      expect(contact).to be_invalid

      contact.birth_date = "19700101"
      expect(contact).to be_valid
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
# rubocop:enable RSpec/EmptyExampleGroup
