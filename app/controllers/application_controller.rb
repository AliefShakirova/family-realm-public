# это базовый контроллер от которого наследуются все остальные, в нем описываются общие для всех наследуемых контроллеров методы
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :accept_pending_invite

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :avatar])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name,
      :last_name,
      :patronymic,
      :maiden_name,
      :birth_date,
      :birth_place,
      :gender,
      :description
    ])
  end

  private

  def user_not_authorized
    flash[:notice] = "You, are not authorized to do this"
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
