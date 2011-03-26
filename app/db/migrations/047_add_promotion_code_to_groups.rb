class AddPromotionCodeToGroups < ActiveRecord::Migration
  def self.up
		add_column :groups, :promotion_code, :string
		add_column :groups, :invites_remaining, :integer
		add_column :groups, :website, :string		
  end
  
  def self.down
		remove_column :groups, :promotion_code
		remove_column :groups, :invites_remaining
		remove_column :groups, :website
  end
end
