FactoryBot.define do
  factory :contact do
    association :contact_list
    details {
      {
        address: Faker::Address.full_address,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 70).to_s,
        credit_card: Faker::Finance.credit_card(:visa).delete("-"),
        email: Faker::Internet.safe_email,
        name: I18n.transliterate(Faker::Name.name).gsub(Contact::NAME_ALLOWED, ""),
        phone: "(+99) 999 999 99 99"
      }
    }
  end
end
