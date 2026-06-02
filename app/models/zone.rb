class Zone < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }


  def tickets_left
    capacity - tickets.count
  end


  def dynamic_price
    tickets_left_result = tickets_left
    if (tickets_left_result / capacity.to_f) < 0.25
      self.price * 1.5
    elsif (tickets_left_result / capacity.to_f) < 0.5
      self.price * 1.2
    else
      self.price
    end
  end
end
