class ChangeJamSongDescriptionToText < ActiveRecord::Migration
  def self.up
		change_column :jams, :description, :text
		change_column :songs, :description, :text
  end
  
  def self.down
		change_column :jams, :description, :string
		change_column :songs, :description, :string
	end
end
