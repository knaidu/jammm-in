class CreateGenresAndUserGenresTables < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :genres do |i|
      i.column :name, :string
    end    
    
    create_table :contains_genres do |i|
      i.column :genre_id, :integer
      i.column :for_type, :string
      i.column :for_type_id, :integer
    end    
    
  end
  
  def self.down
    drop_table :contains_genres
    drop_table :genres
  end

end