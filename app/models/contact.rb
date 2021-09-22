class Contact < ApplicationRecord
  include CreditCard

  belongs_to :contact_list
  has_one :user, through: :contact_lists

  jsonb_accessor :details,
    address: :string,
    birth_date: :string,
    credit_card: :string,
    encrypted_card: :jsonb

  validates :address, presence: true
  validates :birth_date, iso8601: true, presence: true
  validates :credit_card, credit_card: true
  validates :credit_card, presence: true

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
    else
      self.encrypted_card = nil
    end
  end
end
