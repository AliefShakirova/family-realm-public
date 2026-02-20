class TimelineEvent < ApplicationRecord
  belongs_to :group

  belongs_to :ancestor, optional: true
end
