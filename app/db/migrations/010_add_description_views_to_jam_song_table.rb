class AddDescriptionViewsToJamSongTable < ActiveRecord::Migration
  def self.up
		add_column :jams, :description, :string
		add_column :jams, :views, :integer
		add_column :songs, :views, :integer
  end
  
  def self.down
		remove_column :jams, :views
   	remove_column :jams, :description
		remove_column :songs, :views   	
  end
end
