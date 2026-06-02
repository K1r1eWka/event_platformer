class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :zone
  enum :status, { reserved: "reserved", paid: "paid", used: "used", refunded: "refunded" }, default: :reserved

  validate :isTicketsInZone


  private

  def isTicketsInZone
    if zone.tickets_left <= 0
      errors.add(:tickets, "Tickets are sold out!")
    end
  end
end
