# A first-class relationship with User to hold all contacts and keep track of the file
# that has them.

class ContactList < ApplicationRecord
  include Attachable

  belongs_to :user
  has_one_attached :contacts_file
  has_many :contacts, dependent: :destroy

  enum status: { on_hold: 0, processing: 1, failed: 2, finished: 3 }

  validate :acceptable_contacts_file

  def acceptable_contacts_file
    attachment_valid?(contacts_file, ["text/csv"], 1.megabyte, :contacts_file)
  end
end
