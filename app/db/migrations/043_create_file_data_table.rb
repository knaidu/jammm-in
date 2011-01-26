class CreateFileDataTable < ActiveRecord::Migration
  
  def self.up
    create_table :file_data do |i|
      i.column :file_handle, :string
      i.column :length, :integer
      i.column :samplerate, :integer
      i.column :filesize, :integer
      i.column :bitrate, :integer
      i.column :mode, :string
      i.column :waveform_path, :string
    end    
    
  end
  
  def self.down
    drop_table :file_data
  end
end
