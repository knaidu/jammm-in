class CreateSongLyricsTable < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :song_lyrics do |i|
      i.column :song_id, :integer
      i.column :user_id, :integer
      i.column :lyrics, :text
    end    
  end
  
  def self.down
    drop_table :song_lyrics
  end
end
