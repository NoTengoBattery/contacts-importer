class ContactError < ApplicationRecord
  belongs_to :contact_list
  has_one :user, through: :contact_list
end
