FactoryBot.define do
  factory :contact_list do
    user { FactoryBot.create(:user) }
    contacts_file { Rack::Test::UploadedFile.new("spec/fixtures/files/contacts.csv", "text/csv") }
  end
end
