class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.string :target_fname
      t.string :target_lname
      t.string :target_email
      t.boolean :accepted
      t.string :code

      t.timestamps
    end
  end
end
