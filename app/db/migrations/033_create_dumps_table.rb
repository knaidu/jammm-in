class CreateDumpsTable < ActiveRecord::Migration
  def self.up
    create_table :dumps do |i|
      i.column :created_at, :timestamp
      i.column :file_handle, :string
    end    
  end
  
  def self.down
    drop_table :dumps
  end  
end