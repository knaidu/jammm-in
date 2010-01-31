class CreateTagsTable < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :tags do |i|
      i.column :name, :string
    end        
    
    create_table :contains_tags do |i|
      i.column :tag_id, :integer
      i.column :for_type, :string
      i.column :for_type_id, :integer
    end
  end
  
  def self.down
    drop_table :tags
    drop_table :contains_tags
  end

end