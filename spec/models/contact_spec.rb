require "rails_helper"
require "shared_rutines"

RSpec.describe Contact, type: :model do
  subject(:contact) { FactoryBot.build(:contact) }

  context "with validations" do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:credit_card) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to allow_value("371449635398431").for(:credit_card) }
    it { is_expected.not_to allow_value("371449635398430").for(:credit_card) }
    it { is_expected.to allow_value("software@notengobattery.com").for(:email) }
    it { is_expected.not_to allow_value("software@notengobattery,com").for(:email) }
    it { is_expected.to allow_value("Oever Gonzalez").for(:name) }
    it { is_expected.to allow_value("Oever-Gonzalez").for(:name) }
    it { is_expected.not_to allow_value("Oever-González").for(:name) }
    it { is_expected.to allow_value("(+99) 999 999 99 99").for(:phone) }
    it { is_expected.to allow_value("(+99) 999-999-99-99").for(:phone) }
    # it { is_expected.not_to allow_value("(+99) 999 999-99 99").for(:phone) }
  end

  describe "#save" do
    context "with valid card" do
      let(:card) { "5610591081018250" }
      let(:censored) { "************8250" }

      it "encrypts the credit card number" do
        contact.credit_card = card
        contact.save
        expect(contact.encrypted_card.with_indifferent_access).to(
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
