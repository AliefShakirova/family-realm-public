class GroupInvitationsController < ApplicationController
  def show
    @invitation = GroupInvitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.expired?
      redirect_to root_path, alert: "Приглашение недействительно"
    end
  end

  def accept
    invitation = GroupInvitation.find_by(token: params[:token])

    if invitation.nil? || invitation.expired?
      redirect_to root_path, alert: "Приглашение недействительно"
      return
    end

    unless current_user
      session[:invite_token] = invitation.token
      redirect_to new_user_registration_path, alert: "Сначала зарегистрируйтесь"
      return
    end

    GroupMember.create!(
      user: current_user,
      group: invitation.group,
      role: "member"
    )

    invitation.update(status: "accepted")

    redirect_to invitation.group, notice: "Вы вступили в группу"
  end
end
