class CreateFollowersTable < ActiveRecord::Migration
  def self.up
    create_table :followers do |i|
      i.column :user_id, :integer
      i.column :follows_user_id, :integer
    end
  end
  
  def self.down
    drop_table :followers
  end
end
