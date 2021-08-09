require "rails_helper"

RSpec.describe ExtractCsvJob, type: :job do
  describe "#perform_later" do
    subject(:contact_list) { FactoryBot.create(:contact_list) }

    it "extracts data form a CSV file" do
      ActiveJob::Base.queue_adapter = :test
      described_class.perform_later(resource: contact_list)
      expect(described_class).to have_been_enqueued
    end
  end

  describe "#create_ir" do
    subject(:contact_list) { FactoryBot.create(:contact_list) }

    it "saves a CSV to an IR" do
      ActiveJob::Base.queue_adapter = :test
      job = described_class.new
      job.perform(resource: contact_list)
      expect(contact_list).to be_persisted
    end

    it "parses a CSV into an IR" do
      ActiveJob::Base.queue_adapter = :test
      job = described_class.new
      job.perform(resource: contact_list)
      expect(contact_list.ir).not_to be_empty
    end
  end
end
