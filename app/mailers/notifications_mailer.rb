class NotificationsMailer < ApplicationMailer

  def signup
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def forgot_password
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def invoice
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
