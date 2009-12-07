class CreateFeedsAndUserFeedsTables < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :feeds do |i|
      i.column :data, :string
      i.column :feed_type, :string
      i.column :created_at, :timestamp, :default => Time.now
    end    
    
    create_table :user_feeds do |i|
      i.column :feed_id, :integer
      i.column :user_id, :integer
    end
    
  end
  
  def self.down
    drop_table :feeds
    drop_table :user_feeds
  end
end
