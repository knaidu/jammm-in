class CreateSiteCounterTable < ActiveRecord::Migration
  
  def self.up
    
    create_table :site_counter do |i|
      i.column :url, :string
      i.column :counter, :integer, :default => 1
    end    
    
  end
  
  def self.down
    drop_table :site_counter
  end
end
