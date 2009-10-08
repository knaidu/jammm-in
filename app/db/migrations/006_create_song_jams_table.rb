class CreateSongJamsTable < ActiveRecord::Migration
  def self.up
    create_table :song_jams do |i|
      i.column :song_id, :integer
      i.column :jam_id, :integer
    end
  end
  
  def self.down
    drop_table :song_jams
  end
end
