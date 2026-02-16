class GroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user_id, uniqueness: { scope: :group_id } #не позволяет одному пользователю добавится в группу дважды
end
