require "rails_helper"
require "shared_rutines"

RSpec.describe CreditCardValidator do
  subject(:rtest) do
    (Class.new do
      include ActiveModel::Validations
      attr_accessor :dummy
      validates :dummy, credit_card: true

      def self.model_name
        ActiveModel::Name.new(self, nil, "Test Dummy")
      end
    end).new
  end

  context "with invalid credit card" do
    [
      nil, "", "invalid", 1234, :invalid,
      "378282246310004", "378285246310005",
      "5555555555554443", "5555555515554444",
      "5155555555554447", "5155555515554448",
      "5355555555554445", "5355555515554446",
      "41111111111113", "42111111111114",
      "4111111111111110", "4211111111111111"
    ].each do |input|
      describe "#{input.class} credit card with value #{input.inspect}" do
        it "fails validation" do
          rtest.dummy = input
          expect(rtest).to be_invalid
        end
      end
    end
  end

  context "with valid credit card" do
    [
      "378282246310005",
      "5555555555554444", "5155555555554448", "5355555555554446",
      "41111111111114", "4111111111111111"
    ].each do |input|
      describe "#{input.class} credit card with value #{input.inspect}" do
        it "passes validation" do
          rtest.dummy = input
          expect(rtest).to be_valid
        end
      end
    end
  end
end
