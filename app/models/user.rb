class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_profile, dependent: :destroy #один пользователь имеет один профиль(у пользователя есть профиль), при удалении пользователя удаляется и профиль
  #after_create :create_user_profile

  enum role: [:enduser, :admin, :superadmin]
  #после создания нового обьекта пользователя, автоматически будет присвоен enduser, если роль не указана вручную
  after_initialize :set_default_role, :if => :new_record? #after_initialize - это callback, то есть автоматическое действие

  #Powiązanie z postami - kluczowe dla działania current_user.posts
  has_many :posts, dependent: :destroy #убрать или проверить согласно контроллеру постов

  has_many :owned_groups, class_name: 'Group', foreign_key: :owner_id

  has_many :group_members, dependent: :destroy #группы где пользователь owner(то есть создатель)
  #has_many :member_groups, through: :group_members, source: :group #группы где пользователь участник

  has_many :groups, through: :group_members #для появления у пользователя групп в которых он состоит, и куда его пригласили

  has_many :sent_invitations, class_name: "GroupInvitation", foreign_key: :invited_by
  #метод который назначет роль enduser по умолчанию, если роль не присвоена вручную
  def set_default_role
    self.role ||= :enduser
  end

  private

  #автоматически создается пользовательский профиль после регистрации и создании пользователя
  def create_user_profile
    UserProfile.create(user: self)
  end
end
