class SheetMusic < ActiveRecord::Base
  set_table_name "sheet_music"
  belongs_to :jam
  
  def self.add(jam, sheet_type, description, file)
    storage_dir = ENV['STORAGE_DIR']
    filename = new_file_handle_name(false)    
    File.copy(file.path, storage_dir + "/" + filename)
    self.create({
      :jam_id => jam.id,
      :description => description,
      :sheet_type => sheet_type,
      :file_handle => filename
    })
  end
  
  
end
