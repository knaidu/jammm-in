class CreateSongAndJamCommentsTable < ActiveRecord::Migration
  
  # This migration creates two tables.
  
  def self.up
    
    # Jam Likes Table
    create_table :song_comments do |i|
      i.column :song_id, :integer
      i.column :user_id, :integer
      i.column :comment, :string
    end
    
    # Song Like Table
    create_table :jam_comments do |i|
      i.column :jam_id, :integer
      i.column :user_id, :integer
      i.column :comment, :string
    end    
  end
  
  def self.down
    drop_table :song_comments
    drop_table :jam_comments
  end
end
