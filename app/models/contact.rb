class Contact < ApplicationRecord
  NAME_FORMAT = /\A[a-z -]*\z/i
  NAME_ALLOWED = /[^a-z -]/i
  PHONE_FORMAT = /\(\+\d{2}\)\ \d{3}[ -]\d{3}[ -]\d{2}[ -]\d{2}/

  include CreditCard

  belongs_to :contact_list
  has_one :user, through: :contact_lists

  attr_accessor :encrypted_card

  jsonb_accessor :details,
    address: :string,
    birth_date: :string,
    credit_card: :string,
    encrypted_card: :jsonb,
    email: :string,
    name: :string,
    phone: :string

  validates :address, presence: true
  validates :birth_date, iso8601: true, presence: true
  validates :credit_card, credit_card: true, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true
  validates :name, format: {with: NAME_FORMAT}, presence: true
  validates :phone, format: {with: PHONE_FORMAT}, presence: true

  after_validation :encrypt_card

  private

  def encrypt_card
    card_check_info = valid_card?(credit_card)
    if card_check_info
      self.encrypted_card = encrypted_card || {}
      encrypted_card[:censored] = ("*" * (card_check_info[:length] - 4)) + credit_card.last(4)
      encrypted_card[:encrypted] = Digest::MD5.hexdigest(credit_card)
      encrypted_card[:franchise] = card_check_info[:franchise][:name]
      self.credit_card = "*"
    end
  end
end
