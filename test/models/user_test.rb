require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not create user without fname" do
    u = User.new
    assert !u.save
  end
  test "should not create user without lname" do
    u = User.new
    assert !u.save
  end
  test "should not create user without email" do
    u = User.new
    assert !u.save
  end
  test "should save user with lowercase email" do
    u = User.create(fname: 'Little', lname: 'Rebel', email: 'LITTLEREBEL@example.com')
    assert_not_nil User.find_by_email('littlerebel@example.com')
  end
  test "should not create user with same email as another" do
    u1 = User.create(fname: 'Little', lname: 'Rebel', email: 'LITTLEREBEL@example.com')
    u2 = User.new(fname: 'Little', lname: 'Rebel2', email: 'littlerebel@example.com')
    assert !u2.save
  end
  test "should have remember token" do
    u = User.create(fname: 'Jon', lname: 'Smith', email: 'jon@smith.com', password: 'letmein')
    assert_not_nil u.remember_token
  end

  test "should have and own root item upon creation" do
    u = create_random_user
    assert !u.root_item.blank?
    assert u.root_item.latest_content.type == 'Container'
    follower = Follower.find_by_user_id_and_item_id(u.id, u.root_item.id)
    assert !follower.blank? && follower.is_owner
  end
  test "should be able to see and edit root item" do
    u = create_random_user
    assert u.can_see_item?(u.root_item) && u.can_edit_item?(u.root_item)
  end
  test "should belong to 'Personal' workspace upon creation" do
    u = create_random_user
    assert !u.workspaces.blank?, "User doesn't have any workspaces"
    assert u.workspaces.first.name == 'Personal', "User's first workspace isn't called 'Personal'"
  end
end
