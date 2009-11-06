class CreateJamArtistsTable < ActiveRecord::Migration
  def self.up
    create_table :jam_artists do |i|
      i.column :jam_id, :integer
      i.column :artist_id, :integer
    end
  end
  
  def self.down
    drop_table :jam_artists
  end
end
