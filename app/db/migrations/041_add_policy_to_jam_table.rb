class AddPolicyToJamTable < ActiveRecord::Migration
  def self.up
		add_column :jams, :policy, :string, :default => "public"
  end
  
  def self.down
		remove_column :jams, :policy
  end
end
