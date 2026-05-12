class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: "user_id"
  # if event was deleted, all zones and tickets related to it should be deleted as well
  has_many :zones, dependent: :destroy
  has_many :tickets, through: :zones, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  # each validation will call lambda with the current object
  validates :starts_at, presence: true, comparison: { greater_than: ->(_) { Time.current } }
  validates :location, presence: true, length: { maximum: 100 }
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
