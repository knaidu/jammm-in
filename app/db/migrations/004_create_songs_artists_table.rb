class CreateSongsArtistsTable < ActiveRecord::Migration
  def self.up
    create_table :song_artists do |i|
      i.column :song_id, :integer
      i.column :artist_id, :integer
    end
  end
  
  def self.down
    drop_table :song_artists
  end
end
