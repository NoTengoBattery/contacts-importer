require "rails_helper"
require "shared_rutines"

# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe Contact, type: :model do
  context "with validations" do
    subject { FactoryBot.build(:contact) }
  end
end
# rubocop:enable RSpec/EmptyExampleGroup
