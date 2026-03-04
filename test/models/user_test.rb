require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "nie powinien zapisać użytkownika bez adresu email i hasła" do
    user = User.new(first_name: "Jan", last_name: "Kowalski")
    assert_not user.save, "Zapisano użytkownika bez wymaganego emaila!"
  end

  test "powinien zapisać poprawnego użytkownika" do
    user = User.new(
      first_name: "anna",
      last_name: "kols",
      email: "anna.kols@familyrealm.com",
      password: "haslo123"
    )

    assert user.save, "nie udalo sie zapisac, blędy #{user.errors.full_messages.join(', ')}"
  end
end