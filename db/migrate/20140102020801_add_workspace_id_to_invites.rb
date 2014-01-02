class AddWorkspaceIdToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :workspace_id, :integer
  end
end
