class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :user_id
      t.integer :item_id
      t.boolean :is_owner
      t.boolean :can_edit

      t.timestamps
    end
  end
end
