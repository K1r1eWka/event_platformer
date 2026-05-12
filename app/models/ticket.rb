class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :zone
  enum :status, { reserved: "reserved", paid: "paid", used: "used", refunded: "refunded" }, default: :reserved
end
