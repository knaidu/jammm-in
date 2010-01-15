class CreateGenresAndUserGenresTables < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :genres do |i|
      i.column :name, :string
    end    
    
    create_table :user_genres do |i|
      i.column :user_id, :integer
      i.column :genre_id, :integer
    end
    
    create_table :jam_genres do |i|
      i.column :jam_id, :integer
      i.column :genre_id, :integer
    end
    
    create_table :song_genres do |i|
      i.column :song_id, :integer
      i.column :genre_id, :integer
    end
    
  end
  
  def self.down
    drop_table :user_genres
    drop_table :jam_genres
    drop_table :song_genres
    drop_table :genres
  end

end