class StoryAncestor < ApplicationRecord
  belongs_to :story
  belongs_to :ancestor
end
