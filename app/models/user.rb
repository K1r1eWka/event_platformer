class User < ApplicationRecord
  has_many :events
  has_many :tickets

  has_secure_password
  enum :role, { attendee: "attendee", organizer: "organizer" }, validate: true

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
