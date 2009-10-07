class CreateSongsTable < ActiveRecord::Migration
  def self.up
    create_table :songs do |i|
      i.column :name, :string
      i.column :description, :string
      i.length :int
      i.timestamp :timestamp, :default => Time.now
    end
  end
  
  def self.down
    drop_table :songs
  end
end
