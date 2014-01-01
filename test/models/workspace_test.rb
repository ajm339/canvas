require 'test_helper'

class WorkspaceTest < ActiveSupport::TestCase
  test "creator should belong to new workspace" do
    u = create_random_user
    w = Workspace.create_with_user_id({ name: 'Test workspace' }, u.id)
    uw = u.workspaces.where(id: w.id).to_a
    assert !uw.blank?
  end
end
