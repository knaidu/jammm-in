class CreateProcessInfoTable < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :process_info do |i|
      i.column :done, :boolean
      i.column :process_id, :integer
      i.column :failed, :boolean
      i.column :message, :string
    end    
  end
  
  def self.down
    drop_table :process_info
  end
end
