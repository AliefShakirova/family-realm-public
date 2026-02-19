class Location < ApplicationRecord
  belongs_to :group

  has_many :events
  has_many :stories

  has_many :events

  validates :name, presence: true
end
