class CreateJamsTable < ActiveRecord::Migration
  def self.up
    create_table :jams do |i|
      i.column :name, :string
      i.column :length, :integer
      i.column :jam_picture_file_handle, :string
      i.column :origin_jam_id, :integer
      i.column :created_at, :timestamp, :default => Time.now
      i.column :added_by_user_id, :integer
    end
  end
  
  def self.down
    drop_table :jams
  end
end
