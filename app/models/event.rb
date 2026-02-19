class Event < ApplicationRecord
  belongs_to :group
  belongs_to :location, optional: true

  # Связь с участниками
  has_many :participations, dependent: :destroy
  has_many :ancestors, through: :participations

  has_many_attached :media

  validates :title, presence: true
  validates :event_date, presence: true
end
