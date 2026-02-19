class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_profile, dependent: :destroy

  enum role: [:enduser, :admin, :superadmin]

  after_initialize :set_default_role, :if => :new_record?

  has_many :posts, dependent: :destroy

  has_many :owned_groups, class_name: 'Group', foreign_key: :owner_id

  has_many :group_members, dependent: :destroy

  has_many :groups, through: :group_members

  has_many :sent_invitations, class_name: "GroupInvitation", foreign_key: :invited_by

  has_many :stories, dependent: :destroy

  def set_default_role
    self.role ||= :enduser
  end

  private

  def create_user_profile
    UserProfile.create(user: self)
  end
end
