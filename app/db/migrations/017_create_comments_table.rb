class CreateCommentsTable < ActiveRecord::Migration
  
  def self.up
    
    # Comments Table
    create_table :comments do |i|
      i.column :user_id, :integer
      i.column :comment, :string
      i.column :for_type, :string
      i.column :for_type_id, :integer
    end
    
  end
  
  def self.down
    drop_table :comments
  end
end
