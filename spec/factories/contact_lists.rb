FactoryBot.define do
  factory :contact_list do
    status { 0 }
    user { FactoryBot.create(:user) }
    contacts_file { Rack::Test::UploadedFile.new("spec/fixtures/files/contacts.csv", "text/csv") }
  end
end
