class AddActiveForSongJamsTable < ActiveRecord::Migration
  def self.up
		add_column :song_jams, :active, :boolean
  end
  
  def self.down
		remove_column :song_jams, :active
  end
end
