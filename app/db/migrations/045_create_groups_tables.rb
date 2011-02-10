class CreateGroupsTables < ActiveRecord::Migration
  
  def self.up
    create_table :groups do |i|
      i.column :name, :string
      i.column :handle, :string
      i.column :address, :string
      i.column :description, :string
      i.column :phone, :string
      i.column :public, :boolean, :default => false
      i.column :profile_picture, :string
      i.column :profile_picture_thumbnail, :string
      i.column :category_id, :integer
    end    
    
    create_table :group_users do |i|
      i.column :group_id, :integer
      i.column :user_id, :integer
    end
    
    create_table :group_admins do |i|
      i.column :group_id, :integer
      i.column :user_id, :integer
    end
    
    create_table :group_categories do |i|
      i.column :name, :string
      i.column :description, :string
    end
    
  end
  
  def self.down
    drop_table :groups
    drop_table :group_users
    drop_table :group_admins
    drop_table :group_categories
  end
end
