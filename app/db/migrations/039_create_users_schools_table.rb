class CreateUsersSchoolsTable < ActiveRecord::Migration
  
  def self.up
    
    create_table :users_schools do |i|
      i.column :school_id, :integer
      i.column :user_id, :integer
    end    
    
  end
  
  def self.down
    drop_table :users_schools
  end
end
