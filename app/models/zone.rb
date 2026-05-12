class Zone < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
