class AddColumnsForV10 < ActiveRecord::Migration
  def self.up
		add_column :user_feeds, :feed_type, :string, :default => "feed"
  end
  
  def self.down
		remove_column :user_feeds, :feed_type
  end
end
