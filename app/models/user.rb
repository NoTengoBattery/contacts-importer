class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  has_many :contact_lists, dependent: :destroy
end
