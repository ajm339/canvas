class CleanUpItemContentSubclasses < ActiveRecord::Migration
  def up
    drop_table :collections
    drop_table :notes
    drop_table :media_files
    drop_table :events
    drop_table :tasks
    drop_table :messages
  end
  def down
    create_table :collections do |t| t.timestamps end
    create_table :notes do |t| t.timestamps end
    create_table :media_files do |t| t.timestamps end
    create_table :events do |t| t.timestamps end
    create_table :tasks do |t| t.timestamps end
    create_table :messages do |t| t.timestamps end
  end
end
