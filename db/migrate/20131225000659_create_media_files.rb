class CreateMediaFiles < ActiveRecord::Migration
  def change
    create_table :media_files do |t|

      t.timestamps
    end
  end
end
