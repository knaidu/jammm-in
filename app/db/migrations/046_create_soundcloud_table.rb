class CreateSoundcloudTable < ActiveRecord::Migration
  
  def self.up
    create_table :soundcloud_connect do |i|
      i.column :user_id, :integer
      i.column :access_token, :string
      i.column :refresh_token, :string
      i.column :expires_at, :timestamp
      i.column :imports_remaining, :integer, :default => 3
    end    
  end
  
  def self.down
    drop_table :soundcloud_connect
  end
end
