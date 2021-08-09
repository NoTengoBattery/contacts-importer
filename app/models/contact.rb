class Contact < ApplicationRecord
  belongs_to :contact_list
  has_one :user, through: :contact_lists
end
