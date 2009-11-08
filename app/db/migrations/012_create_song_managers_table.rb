class CreateSongManagersTable < ActiveRecord::Migration
  def self.up
    create_table :song_managers do |i|
      i.column :song_id, :integer
      i.column :manager_id, :integer
    end
  end
  
  def self.down
    drop_table :song_managers
  end
end
