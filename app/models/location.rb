class Location < ApplicationRecord
  belongs_to :group

  has_many :events
  has_many :stories

  validates :name, presence: true
end
