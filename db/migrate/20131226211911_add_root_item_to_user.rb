class AddRootItemToUser < ActiveRecord::Migration
  def change
    add_column :users, :root_item_id, :integer
  end
end
