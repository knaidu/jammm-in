class CreateSheetMusicTable < ActiveRecord::Migration
  
  def self.up
    create_table :sheet_music do |i|
      i.column :jam_id, :integer
      i.column :sheet_type, :string
      i.column :file_handle, :string
      i.column :description, :text
    end    
    
  end
  
  def self.down
    drop_table :sheet_music
  end

end
