# frozen_string_literal: true

class ApplicationPolicy

  # record - объект, к которому проверяется доступ,  данном случаем к пользователю

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    private

    attr_reader :user, :scope
  end
end
