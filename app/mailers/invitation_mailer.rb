class InvitationMailer < ApplicationMailer
  def invite(email, group, token)
    @group = group
    @url = invite_url(token)

    mail(to: email, subject: "Приглашение в группу #{group.name}")
  end
end
