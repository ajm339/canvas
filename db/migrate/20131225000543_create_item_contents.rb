class CreateItemContents < ActiveRecord::Migration
  def change
    create_table :item_contents do |t|
      t.integer :user_id
      t.integer :version
      t.integer :item_id
      t.string :type
      t.text :content
      t.string :url
      t.string :name
      t.string :location
      t.datetime :start_time
      t.boolean :is_all_day
      t.datetime :end_time
      t.integer :alert
      t.boolean :is_checked
      t.integer :order

      t.timestamps
    end
  end
end
