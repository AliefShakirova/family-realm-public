class Post < ApplicationRecord
  # Создание модели пост для сохранения постов в базу данных, после создания модели надо сделать rails db:migrate
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5 } # проверка валидации данных введеных при создании поста
end
