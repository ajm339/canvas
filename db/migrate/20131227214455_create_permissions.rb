class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :item_id
      t.boolean :can_see

      t.timestamps
    end
  end
end
