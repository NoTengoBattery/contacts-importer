class ContactError < ApplicationRecord
  belongs_to :contact_list
  belongs_to :user
end
