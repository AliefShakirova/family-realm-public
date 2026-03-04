require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.new(
      first_name: "Test",
      last_name: "User",
      email: "test.controller@familyrealm.com",
      password: "password123"
    )
    @user.save(validate: false)
  end

  test "powinien przekierować niezalogowanego użytkownika na stronę logowania" do
    get groups_url

    assert_response :redirect
  end

  test "powinien pokazać listę grup dla zalogowanego użytkownika" do
    sign_in @user

    get groups_url

    assert_response :success
  end
end