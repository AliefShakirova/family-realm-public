class Ancestor < ApplicationRecord
  belongs_to :group

  has_one_attached :photo
  has_many_attached :documents

  validates :first_name, :last_name, presence: true

  #для того чтоб не сохранялось не нужное
  before_save :clear_irrelevant_fields

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
end
