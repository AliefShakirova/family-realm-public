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
  has_many :posts, dependent: :destroy

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
