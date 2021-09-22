FactoryBot.define do
  factory :contact do
    association :contact_list
    details {
      {
        address: "Fake Addres #24, Fake City",
        birth_date: "20210101",
        credit_card: "4012888888881881"
      }
    }
  end
end
