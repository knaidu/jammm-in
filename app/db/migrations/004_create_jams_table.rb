class CreateJamsTable < ActiveRecord::Migration
  def self.up
    create_table :jams do |i|
      i.column :name, :string
      i.column :length, :integer
      i.column :created_at, :timestamp, :default => Time.now
    end
  end
  
  def self.down
    drop_table :jams
  end
end
