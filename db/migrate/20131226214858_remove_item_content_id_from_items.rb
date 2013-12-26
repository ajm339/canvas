class RemoveItemContentIdFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :item_content_id, :string
  end
end
