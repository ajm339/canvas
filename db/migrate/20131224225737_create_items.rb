class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :position_top
      t.integer :position_left
      t.integer :item_content_id

      t.timestamps
    end
  end
end
