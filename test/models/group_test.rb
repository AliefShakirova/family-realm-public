require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "nie powinien zapisać grupy bez nazwy" do
    group = Group.new
    assert_not group.save, "Zapisano grupę bez podania nazwy"
  end

  test "powinien zapisać poprawną grupę" do

    owner = User.new(
      first_name: "sasha",
      last_name: "Kovalev",
      email: "own@familyrealm.com",
      password: "password123"
    )
    owner.save(validate: false)

    group = Group.new(
      name: "Rodzina kovalev",
      owner: owner,
      privacy: "private"
    )

    assert group.save, "nie udalo sie zapisac, blędy#{group.errors.full_messages.join(', ')}"
  end
end