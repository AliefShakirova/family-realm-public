class Ancestor < ApplicationRecord
  belongs_to :group

  has_one_attached :photo
  has_many_attached :documents

  # Удобные методы для получения людей
  has_many :relatives, through: :active_relationships, source: :relative

  # Связи, где этот человек является главным (например, ОН - отец КОГО-ТО)
  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "ancestor_id",
           dependent: :destroy

  # Связи, где этот человек является целью (например, КТО-ТО - отец ЭТОГО человека)
  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "relative_id",
           dependent: :destroy

  validates :first_name, :last_name, presence: true

  #для того чтоб не сохранялось не нужное
  before_save :clear_irrelevant_fields

  #может быть позже после проверки заменить с методом таким же снизу, чтоб придобавлении предка было фио а не только имя
  #def full_name
  #"#{last_name} #{first_name} #{middle_name}".strip
  #end

  after_initialize do
    self.alive = true if alive.nil?
  end

  def clear_irrelevant_fields
    if alive?
      self.death_date = nil
      self.death_place = nil
    else
      self.phone = nil
      self.current_address = nil
    end
  end

  # Хелперы для конкретных ролей (примеры)
  def parents
    # Родители - это те, кто записан как 'father' или 'mother' по отношению ко мне
    # То есть ищем в passive_relationships (где я - relative), тип father/mother
    passive_relationships.where(relation_type: ['father', 'mother']).map(&:ancestor)
  end

  def children
    # Дети - это те, для кого я являюсь 'father' или 'mother'
    # ИЛИ (если мы записываем связь как 'child') - те, кто у меня в active_relationships с типом 'child'
    active_relationships.where(relation_type: 'child').map(&:relative)
  end

  def spouses
    # Мужья/Жены
    active_relationships.where(relation_type: 'spouse').map(&:relative)
  end

  def full_name
    [first_name, middle_name, last_name].compact.join(' ')
  end
end
