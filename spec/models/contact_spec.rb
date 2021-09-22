require "rails_helper"
require "shared_rutines"

RSpec.describe Contact, type: :model do
  subject(:contact) { FactoryBot.build(:contact) }

  context "with validations" do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:credit_card) }
  end

  describe "#save" do
    context "with valid card" do
      let(:card) { "5610591081018250" }
      let(:censored) { "************8250" }

      it "encrypts the credit card number" do
        contact.credit_card = card
        contact.save
        expect(contact.encrypted_card).to(
          include("censored" => censored)
        )
      end

      it "destroys the original credit card number" do
        contact.credit_card = card
        contact.save
        expect(contact.credit_card).not_to eq(card)
      end

      it "validates after destroying the credit card number" do
        contact.credit_card = card
        contact.save
        contact.save
        expect(contact).to be_valid
      end
    end

    context "with invalid card" do
      let(:card) { "5610591081018251" }

      it "does not destroy the credit card number" do
        contact.credit_card = card
        contact.save
        expect(contact.credit_card).to eq(card)
      end
    end
  end
end
