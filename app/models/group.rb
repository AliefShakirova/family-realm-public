class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :group_members, dependent: :destroy
  has_many :members, through: :group_members, source: :user

  has_many :group_invitations, dependent: :destroy

  has_many :ancestors, dependent: :destroy

  validates :name, presence: true
  validates :privacy, inclusion: { in: %w(private public) }
end
