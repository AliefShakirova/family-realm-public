class Relationship < ApplicationRecord
  belongs_to :group
  belongs_to :ancestor, class_name: "Ancestor"
  belongs_to :relative, class_name: "Ancestor"

  validates :relation_type, presence: true
  validate :cannot_link_to_self

  TYPES = ['father', 'mother', 'spouse', 'child', 'sibling']

  private

  def cannot_link_to_self
    errors.add(:relative_id, "не может быть тем же человеком") if ancestor_id == relative_id
  end
end

