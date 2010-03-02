class CreateUserBadgesTable < ActiveRecord::Migration
  
  def self.up
    create_table :user_badges do |i|
      i.column :user_id, :integer
      i.column :badge_id, :integer
      i.column :created_at, :timestamp
    end    
  end
  
  def self.down
    drop_table :user_badges
  end
end
