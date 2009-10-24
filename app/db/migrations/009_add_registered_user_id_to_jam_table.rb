class AddRegisteredUserIdToJamTable < ActiveRecord::Migration
  def self.up
		add_column :jams, :registered_user_id, :integer
  end
  
  def self.down
		remove_column :jams, :registered_user_id
  end
end
