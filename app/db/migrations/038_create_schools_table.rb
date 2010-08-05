class CreateSchoolsTable < ActiveRecord::Migration
  
  def self.up
    
    create_table :schools do |i|
      i.column :name, :string
      i.column :handle, :string
      i.column :address, :text
      i.column :phone_number, :string
    end    
    
  end
  
  def self.down
    drop_table :schools
  end
end
