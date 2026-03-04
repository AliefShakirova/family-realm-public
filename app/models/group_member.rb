class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :group_members, dependent: :destroy

  has_many :users, through: :group_members

  validates :user_id, uniqueness: { scope: :group_id } #не позволяет одному пользователю добавится в группу дважды
end
