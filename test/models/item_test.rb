require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "Create child item for user" do
    u = create_random_user
    c = Container.create
    ri = Item.create(position_top: 0, position_left: 0, is_root: true, creator_id: u.id, latest_content_id: c.id)
    item_params = { 
      position_top: 20,
      position_left: 20,
      latest_content: {
        type: 'Note',
        version: 1
      }
    }
    item = Item.create_with_params_and_parent_for_user(item_params, ri.id, u.id)
    assert_not_nil item.id
    assert_not_nil Item.find(item.id)
    assert ri.children.include? item
    f = Follower.find_by_user_id_and_item_id(u.id, item.id)
    assert !f.blank?
    assert f.is_owner
    assert f.can_edit
    p = Permission.find_by_user_id_and_item_id(u.id, item.id)
    assert !p.blank?
    assert p.can_see
  end
  # test "Item validations" do
  #   i = Item.new
  #   assert !Item.save
  # end
  # test "Make sure every item has a position (default to (0,0))" do
  #   ri = Item.create(is_root: true, creator_id: u.id, latest_content_id: c.id)
  #   assert ri.position_left == 0
  #   assert ri.position_top == 0
  # end
end
