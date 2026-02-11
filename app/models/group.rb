class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true
  validates :privacy, inclusion: { in: %w(private public) }
end
