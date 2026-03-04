require "test_helper"

class NotificationsMailerTest < ActionMailer::TestCase
  test "signup" do
    mail = NotificationsMailer.signup
    assert_equal "Signup", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@familyrealm.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "forgot_password" do
    mail = NotificationsMailer.forgot_password
    assert_equal "Forgot password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@familyrealm.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "invoice" do
    mail = NotificationsMailer.invoice
    assert_equal "Invoice", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@familyrealm.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
