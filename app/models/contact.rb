class Contact < ApplicationRecord
  belongs_to :contact_list
  has_one :user, through: :contact_lists

  jsonb_accessor :details,
    address: :string,
    birth_date: :string,
    credit_card: :string

  validates :address, presence: true
  validates :birth_date, iso8601: true, presence: true
end
