class CreateJamAndSongLikesTable < ActiveRecord::Migration
  
  # This migration creates two tables.
  
  def self.up
    
    # Jam Likes Table
    create_table :jam_likes do |i|
      i.column :jam_id, :integer
      i.column :user_id, :integer
    end
    
    # Song Like Table
    create_table :song_likes do |i|
      i.column :song_id, :integer
      i.column :user_id, :integer
    end    
  end
  
  def self.down
    drop_table :song_likes
    drop_table :jam_likes
  end
end
