class CreateUserTable < ActiveRecord::Migration
  def self.up
    create_table :users, {:id => true} do |i|
      i.column :username, :string
      i.column :password, :string
      i.column :name, :string
      i.column :location, :string
      i.column :email, :string
    end
  end
  
  def self.down
    drop_table :users
  end
end
