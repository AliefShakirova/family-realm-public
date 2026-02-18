class Relationship < ApplicationRecord
  belongs_to :group
  # Указываем, что оба поля ведут к модели Ancestor
  belongs_to :ancestor, class_name: "Ancestor"
  belongs_to :relative, class_name: "Ancestor"

  # Валидации: тип связи обязателен, и нельзя связать человека с самим собой
  validates :relation_type, presence: true
  validate :cannot_link_to_self

  # Список возможных типов связей (Enum или константы)
  TYPES = ['father', 'mother', 'spouse', 'child', 'sibling']

  private

  def cannot_link_to_self
    errors.add(:relative_id, "не может быть тем же человеком") if ancestor_id == relative_id
  end
end

