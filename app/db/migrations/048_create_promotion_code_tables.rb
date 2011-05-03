class CreatePromotionCodeTables < ActiveRecord::Migration
  
  def self.up
    create_table :promotion_codes do |i|
      i.column :code, :string
      i.column :invites_remaining, :integer, :default => 50
    end    
    
    create_table :promotion_code_users do |i|
      i.column :promotion_code_id, :integer
      i.column :user_id, :integer
    end
    
  end
  
  def self.down
    drop_table :promotion_codes
    drop_table :promotion_code_users
  end
  
end
