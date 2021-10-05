FactoryBot.define do
  n = Faker::Number.method(:number)
  factory :contact do
    association :contact_list
    details {
      {
        address: Faker::Address.full_address,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 70).to_s,
        credit_card: Faker::Finance.credit_card(:visa).delete("-"),
        email: Faker::Internet.safe_email,
        name: I18n.transliterate(Faker::Name.name).gsub(Contact::NAME_ALLOWED, ""),
        phone: "(+#{n.call(digits: 2)}) #{n.call(digits: 3)} #{n.call(digits: 3)} #{n.call(digits: 2)} #{n.call(digits: 2)}"
      }
    }
  end
end
