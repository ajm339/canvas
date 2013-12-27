class AddLatestContentIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :latest_content_id, :integer
  end
end
