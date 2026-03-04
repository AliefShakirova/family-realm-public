require "test_helper"

class AncestorTest < ActiveSupport::TestCase
  test "nie powinien zapisać przodka bez przypisanej grupy" do
    ancestor = Ancestor.new(first_name: "piotr", last_name: "trun")
    assert_not ancestor.save, "Zapisano przodka bez przypisania go do grupy rodzinnej"
  end

  test "powinien zapisać poprawnego przodka w grupie" do
    owner = User.new(first_name: "katya", last_name: "adam", email: "own@test.com", password: "password")
    owner.save(validate: false)

    group = Group.new(name: "Grupa katya", owner: owner, privacy: "private")
    group.save(validate: false)

    ancestor = Ancestor.new(
      first_name: "katya",
      last_name: "adam",
      group: group
    )

    assert ancestor.save, "nie udalo sie zapisac, blędy #{ancestor.errors.full_messages.join(', ')}"
  end
end