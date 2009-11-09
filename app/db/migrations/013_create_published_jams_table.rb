class CreatePublishedJamsTable < ActiveRecord::Migration
  def self.up
    create_table :published_jams do |i|
      i.column :jam_id, :integer
    end
  end
  
  def self.down
    drop_table :published_jams
  end
end
