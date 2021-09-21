require "rails_helper"
require "shared_rutines"

RSpec.describe Iso8601Validator do
  subject(:rtest) do
    (Class.new do
      include ActiveModel::Validations
      attr_accessor :dummy
      validates :dummy, iso8601: true

      def self.model_name
        ActiveModel::Name.new(self, nil, "Test Dummy")
      end
    end).new
  end

  context "with invalid ISO8601 date" do
    [
      nil, "", "invalid", 20210101, Time.zone.now
    ].each do |input|
      describe "#{input.class} date with value #{input.inspect}" do
        it "fails validation" do
          rtest.dummy = input
          expect(rtest).to be_invalid
        end
      end
    end
  end

  context "with valid ISO8601" do
    [
      "20211231", "19700101", "2021-12-31", "1970-01-10"
    ].each do |input|
      describe "#{input.class} date with value #{input.inspect}" do
        it "passes validation" do
          rtest.dummy = input
          expect(rtest).to be_valid
        end
      end
    end
  end
end
