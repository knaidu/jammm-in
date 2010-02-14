class CreateConnectedSitesTables < ActiveRecord::Migration
  
  def self.up
    create_table :facebook_share do |i|
      i.column :user_id, :integer
      i.column :facebook_user_handle, :string
      i.column :facebook_session, :string
      i.column :jam_like, :boolean      
      i.column :song_like, :boolean
      i.column :jam_publish, :boolean
      i.column :song_publish, :boolean
    end    

    create_table :twitter_share do |i|
      i.column :user_id, :integer
      i.column :twitter_user_handle, :string
      i.column :jam_like, :boolean      
      i.column :song_like, :boolean
      i.column :jam_publish, :boolean
      i.column :song_publish, :boolean
    end

  end
  
  def self.down
    drop_table :facebook_share
    drop_table :twitter_share
  end
end
