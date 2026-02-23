class Post < ApplicationRecord
  # Создание модели пост для сохранения постов в базу данных, после создания модели надо сделать rails db:migrate
  belongs_to :user

  has_one_attached :attachment

  validates :title, presence: true, length: { minimum: 5 } # проверка валидации данных введеных при создании поста
end
