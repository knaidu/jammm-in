class CreateUserTable < ActiveRecord::Migration
  def self.up
    create_table :users, {:id => true} do |i|
      i.column :username, :string
      i.column :password, :string
      i.column :name, :string
      i.column :location, :string
      i.column :email, :string
      i.column :profile_picture_file_handle, :string
      i.column :log_in_counter, :integer, :default => 1
      i.column :created_at, :timestamp, :default => Time.now
      i.column :invites_remaining, :integer, :default => 3
    end
  end
  
  def self.down
    drop_table :users
  end 
end
