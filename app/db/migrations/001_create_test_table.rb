class CreateTestTable < ActiveRecord::Migration
  def self.up
    create_table :test_tables, {:id => true} do |i|
      i.column :test_col, :string
    end
  end
  
  def self.down
    drop_table :test_tables
  end
end