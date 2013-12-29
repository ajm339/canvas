class RecreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :parent_id
      t.integer :item_id

      t.timestamps
    end
  end
end
