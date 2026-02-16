# это базовый контроллер от которого наследуются все остальные, в нем описываются общие для всех наследуемых контроллеров методы
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # защита от подделанных запросов
  protect_from_forgery with: :exception
  # обработка отказа в доступе пользователю, если делает то что ему не положено. Вместо ошибки идет метод user_not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :accept_pending_invite

  private

  # выбрасывается ошибка, и ловится методом user_not_authorized, и выводится сообщение
  def user_not_authorized
    flash[:notice] = "You, are not authorized to do this"
    # после выведения ошибки, перенаправляет пользователя на предыдущую или главную страницу.
    redirect_to(request.referrer || root_path)
  end

  def accept_pending_invite
    return unless current_user
    return unless session[:invite_token]

    invitation = GroupInvitation.find_by(token: session[:invite_token])

    if invitation&.pending?
      GroupMember.create!(
        user: current_user,
        group: invitation.group,
        role: "member"
      )

      invitation.update(status: "accepted")
    end

    session[:invite_token] = nil
  end
end
