class AddSchoolIdToInviteTable < ActiveRecord::Migration
  def self.up
		add_column :invites, :school_id, :integer, :default => nil
  end
  
  def self.down
		remove_column :invites, :school_id
  end
end
