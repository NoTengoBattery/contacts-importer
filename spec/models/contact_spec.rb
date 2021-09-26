require "rails_helper"
require "shared_rutines"

RSpec.describe Contact, type: :model do
  subject(:contact) { FactoryBot.create(:contact) }

  context "with validations" do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:credit_card) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:phone) }

    ["4709195919792", "4417772164978", "3528274953930987"].each do |card|
      it { is_expected.to allow_value(card).for(:credit_card) }
    end
    ["software@notengobattery.com", "test@example.com", Faker::Internet.email].each do |email|
      it { is_expected.to allow_value(email).for(:email) }
    end
    ["software@notengobattery,com", "test@example@com"].each do |email|
      it { is_expected.not_to allow_value(email).for(:email) }
    end
    ["notengobattery", "no-tengo-battery"].each do |name|
      it { is_expected.to allow_value(name).for(:name) }
    end
    ["no#tengo#battery", "nóténgóbáttéry"].each do |name|
      it { is_expected.not_to allow_value(name).for(:name) }
    end
    ["(+99) 999 999 99 99",
      "(+00) 000 000 00 00",
      "(+99) 999-999-99-99",
      "(+00) 000-000-00-00"].each do |phone|
      it { is_expected.to allow_value(phone).for(:phone) }
    end
    ["(+99) 999-999 99 99",
      "(+99)-999 999 99 99",
      "(+99) 99 999 99 99",
      "+99 999 999 99 99",
      "+999999999999"].each do |phone|
      it { is_expected.not_to allow_value(phone).for(:phone) }
    end
  end

  describe "#save" do
    context "with valid card" do
      let(:card) { "5610591081018250" }
      let(:censored) { "************8250" }

      it "encrypts the credit card number" do
        contact.credit_card = card
        contact.save
        the_contact = described_class.find(contact.id)
        expect(the_contact.encrypted_card).to(include("censored" => censored))
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
