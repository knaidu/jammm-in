class AddRegisteredUserIdToSongTable < ActiveRecord::Migration
  def self.up
		add_column :songs, :registered_user_id, :integer
  end
  
  def self.down
		remove_column :songs, :registered_user_id
  end
end
