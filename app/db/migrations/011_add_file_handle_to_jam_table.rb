class AddFileHandleToJamTable < ActiveRecord::Migration
  def self.up
		add_column :jams, :file_handle, :string
  end
  
  def self.down
		remove_column :jams, :file_handle
  end
end
