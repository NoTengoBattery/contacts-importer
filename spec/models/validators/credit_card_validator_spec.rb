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

  # Design consideration:
  # While I may test the valid credit card and add/subtract a randon number and expect it to fail, it may actually not
  # work as expected as the negative test may randomly fail. Adding a constant will not allow the tests to cover edge
  # cases.
  # Crafting the invalid numbers with ones that are guaranteed to be invalid but modified in diverse ways is a better
  # choice.
  context "with invalid credit card" do
    [
      nil, "", "invalid", 1234, :invalid,
      "378282246310004", "378285246310005",
      "5555555555554445", "5555551555554444",
      "5155555555554440", "5155555155554448",
      "5355555555554445", "5355555515554446",
      "41111111111115", "42111111111114",
      "4111111111111110", "4211111111111111",
      "411111111111116", "4111111111119",
      "53555555555544452", "535555555544458"
    ].each do |input|
      context "with type:#{input.class} and value #{input.inspect}" do
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
      context "with type:#{input.class} and value #{input.inspect}" do
        it "passes validation" do
          rtest.dummy = input
          expect(rtest).to be_valid
        end
      end
    end
  end
end
