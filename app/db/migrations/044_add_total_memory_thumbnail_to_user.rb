class AddTotalMemoryThumbnailToUser < ActiveRecord::Migration
  def self.up
		add_column :users, :total_memory, :float, :default => 209715200
		add_column :users, :thumbnail, :string
  end
  
  def self.down
		remove_column :users, :total_memory
		remove_column :users, :thumbnail
  end
end
