class GroupInvitation < ApplicationRecord
  belongs_to :group
  belongs_to :inviter, class_name: 'User', foreign_key: :invited_by

  before_create :generate_token
  before_create :set_expiration

  validates :email, presence: true

  enum status: {
    pending: "pending",
    accepted: "accepted",
    expired: "expired"
  }

  private

  def generate_token
    self.token = SecureRandom.hex(20)
  end

  def set_expiration
    self.expires_at = 7.days.from_now
    self.status = "pending"
  end
end
