require "rails_helper"

RSpec.describe ExtractCsvJob, active_job: true, type: :job do
  describe "#perform_later" do
    subject(:contact_list) { FactoryBot.create(:contact_list) }

    it "extracts data form a CSV file" do
      expect {
        described_class.set(queue: "normal").perform_later(resource: contact_list)
      }.to have_enqueued_job
        .with(resource: contact_list)
        .on_queue("normal").at(:no_wait)
    end
  end

  context "when transitioning statueses" do
    subject(:contact_list) { FactoryBot.create(:contact_list) }

    let(:map) { {"Name" => "name", "Email" => "email", "Phone" => "phone", "Address" => "address", "Credit Card" => "credit_card", "Date of Birth" => "birth_date"} }

    def execute_job
      described_class.perform_now(resource: contact_list)
      contact_list.reload
    end

    def finish_job
      execute_job
      contact_list.status = "mapped"
      contact_list.ir["headers"] = map
      execute_job
    end

    describe "from :on_hold -> :needs_mappings" do
      it("starts with :on_hold") { expect(contact_list.status).to eq("on_hold") }

      it("finish with :needs_mappings") do
        execute_job
        expect(contact_list.status).to eq("needs_mappings")
      end

      it("finish with side effects") do
        execute_job
        expect(contact_list.ir).not_to be_empty
      end
    end

    describe "from :on_hold -> :finished" do
      it("starts with :on_hold") { expect(contact_list.status).to eq("on_hold") }

      it("finish with :finished") do
        finish_job
        expect(contact_list.status).to eq("finished")
      end

      it("finish with side effects") { expect { finish_job }.to change(Contact, :count) }
    end

    describe "from :on_hold -> :failed" do
      before do
        contact_list.contacts_file = Rack::Test::UploadedFile.new("spec/fixtures/files/contacts_fail.csv", "text/csv")
      end

      it("starts with :on_hold") { expect(contact_list.status).to eq("on_hold") }

      it("finish with :failed") do
        finish_job
        expect(contact_list.status).to eq("failed")
      end

      it("finish with side effects") { expect { finish_job }.not_to change(Contact, :count) }
    end
  end
end
