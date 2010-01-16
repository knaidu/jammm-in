class CreateSongsTable < ActiveRecord::Migration
  def self.up
    create_table :songs do |i|
      i.column :name, :string
      i.column :description, :string
      i.column :length, :int
      i.column :song_picture_file_handle, :string
      i.column :created_at, :timestamp, :default => Time.now
    end
  end
  
  def self.down
    drop_table :songs
  end
end
