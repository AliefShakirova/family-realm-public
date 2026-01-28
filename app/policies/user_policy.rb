class UserPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  # отвечает за логику авторизации

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Здесь дается разрешение любому пользователю( даже не вошедшему в систему) доступ к просмотру страницы
  def index?
    true
  end

  # Здесь доступ к этому действию получат только вошедшие в систему пользователи, чьи аккаунты были созданы сегодня и когда значение ключа show в хеше record равно true.
  def show?
    user&.created_at&.today? && record[:show] == true
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
