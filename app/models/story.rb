class Story < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many_attached :media

  has_many :story_ancestors, dependent: :destroy
  has_many :ancestors, through: :story_ancestors

  validates :title, presence: true
  validates :content, presence: true
end
