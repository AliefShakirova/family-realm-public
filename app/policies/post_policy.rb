class PostPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  attr_reader :current_user, :post

  def initialize(current_user, post)
    @current_user = current_user
    @post = post
  end

  def create?
    @current_user.admin?
  end

  def show?
    true
  end

  def update?
    @current_user.admin?
  end

  def destroy?
    @current_user.admin?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
