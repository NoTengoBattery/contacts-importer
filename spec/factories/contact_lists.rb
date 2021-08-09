FactoryBot.define do
  factory :contact_list do
    status { 0 }
    user { User.first }
    policy_file { Rack::Test::UploadedFile.new("spec/fixtures/files/contacts.csv", "text/csv") }
  end
end
