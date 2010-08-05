class CreateSchoolAdmins < ActiveRecord::Migration
  
  def self.up
    
    create_table :school_admins do |i|
      i.column :school_id, :integer
      i.column :user_id, :integer
    end    
    
  end
  
  def self.down
    drop_table :school_admins
  end
end
