class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :attachment

  validates :title, presence: true, length: { minimum: 5 } # проверка валидации данных введеных при создании поста
end
