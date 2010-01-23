class CreateInstrumentsAndContainsIntrumentsTables < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :instruments do |i|
      i.column :name, :string
      i.column :image_url, :string
    end    
    
    create_table :contains_instruments do |i|
      i.column :instrument_id, :integer
      i.column :for_type, :string
      i.column :for_type_id, :integer
    end    
    
  end
  
  def self.down
    drop_table :contains_instruments
    drop_table :instruments
  end

end