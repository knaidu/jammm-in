class AddFileHandleForSongsTable < ActiveRecord::Migration
  def self.up
		add_column :songs, :file_handle, :string
  end
  
  def self.down
		remove_column :songs, :file_handle
  end
end
