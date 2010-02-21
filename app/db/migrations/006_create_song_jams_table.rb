class CreateSongJamsTable < ActiveRecord::Migration
  def self.up
    create_table :song_jams do |i|
      i.column :song_id, :integer
      i.column :jam_id, :integer
      i.column :is_flattened, :bool
      i.column :volume, :float, :default => 1
    end
  end
  
  def self.down
    drop_table :song_jams
  end
end
