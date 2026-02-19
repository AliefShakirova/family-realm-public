class Ancestor < ApplicationRecord
  belongs_to :group

  has_one_attached :photo
  has_many_attached :documents

  has_many :relatives, through: :active_relationships, source: :relative

  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "ancestor_id",
           dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "relative_id",
           dependent: :destroy

  has_many :participations, dependent: :destroy
  has_many :events, through: :participations

  has_many :story_ancestors, dependent: :destroy
  has_many :stories, through: :story_ancestors

  validates :first_name, :last_name, presence: true

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

  def parents
    passive_relationships.where(relation_type: ['father', 'mother']).map(&:ancestor)
  end

  def children
    active_relationships.where(relation_type: 'child').map(&:relative)
  end

  def spouses
    active_relationships.where(relation_type: 'spouse').map(&:relative)
  end

  def full_name
    [last_name, first_name, middle_name].compact.join(' ')
  end
end
