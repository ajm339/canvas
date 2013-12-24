class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :workspace_id
      t.integer :user_id

      t.timestamps
    end
  end
end
