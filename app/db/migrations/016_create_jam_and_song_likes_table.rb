class CreateJamAndSongLikesTable < ActiveRecord::Migration
  
  def self.up
    create_table :likes do |i|
      i.column :user_id, :integer
      i.column :for_type, :string
      i.column :for_type_id, :integer
    end    
  end
  
  def self.down
    drop_table :likes
  end
end
