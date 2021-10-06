# A first-class relationship with User to hold all contacts and keep track of the file
# that has them.

class ContactList < ApplicationRecord
  include Attachable

  MAP_FIELDS = %i[name birth_date phone address credit_card email].freeze
  SHOW_FIELDS = %i[name birth_date_display phone address credit_card_display franchise email].freeze

  belongs_to :user
  has_one_attached :contacts_file
  has_many :contacts, dependent: :destroy

  enum status: {on_hold: 0, processing: 1, needs_mappings: 2, mapped: 3, failed: 4, finished: 5}

  validate :acceptable_contacts_file

  def acceptable_contacts_file
    attachment_valid?(contacts_file, ["text/csv"], 1.megabyte, :contacts_file)
  end

  def self.mappings
    MAP_FIELDS.each_with_object([]) { |field, res| res.push([I18n.t("contact_lists.#{field}"), field]) }
  end

  def mappings() = self.class.mappings

  def self.show_mappings
    SHOW_FIELDS.each_with_object([]) { |field, res| res.push([I18n.t("contact_lists.#{field}"), field]) }
  end

  def show_mappings() = self.class.show_mappings
end
