class AddIsRootToItems < ActiveRecord::Migration
  def change
    add_column :items, :is_root, :boolean
  end
end
