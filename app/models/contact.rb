class Contact < ApplicationRecord
  include CreditCard
  NAME_FORMAT = /\A[a-z -]*\z/i
  NAME_ALLOWED = /[^a-z -]/i
  PHONE_FORMAT = /\(\+\d{2}\)\ (\d{3}-\d{3}-\d{2}-\d{2}|\d{3} \d{3} \d{2} \d{2})/

  belongs_to :contact_list
  belongs_to :user

  jsonb_accessor :details,
    address: :string,
    birth_date: :string,
    credit_card: :string,
    encrypted_card: :json,
    name: :string,
    phone: :string

  validates :address, presence: true
  validates :birth_date, iso8601: true, presence: true
  validates :credit_card, credit_card: true, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true
  # This two uniqueness validations are backed by PostgreSQL indexes. This means that they will not fail due to race
  # conditions. The fact that they exist here is only to provide more meaninful errors of why a contact won't save.
  validates :email, uniqueness: {scope: :user_id}
  validates :email, uniqueness: {scope: :contact_list_id}
  validates :name, format: {with: NAME_FORMAT}, presence: true
  validates :phone, format: {with: PHONE_FORMAT}, presence: true

  after_validation :encrypt_card

  def credit_card_display() = details["encrypted_card"].[]("censored")

  def birth_date_display() = Date.parse(details["birth_date"]).strftime("%Y %B %e")

  def franchise() = details["encrypted_card"]["franchise"].[]("name")

  private

  def encrypt_card
    return unless errors[:credit_card].empty? && credit_card != "*"
    franchise = determine_franchise!(credit_card)
    self.encrypted_card = encrypted_card || HashWithIndifferentAccess.new
    encrypted_card["censored"] = ("*" * (credit_card.size - 4)) + credit_card.last(4)
    encrypted_card["encrypted"] = Digest::MD5.hexdigest(credit_card)
    encrypted_card["franchise"] = franchise
    self.credit_card = "*"
  rescue FranchiseError
    nil
  end
end
