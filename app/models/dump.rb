class Dump < ActiveRecord::Base
  
  before_create {|record| record.created_at = Time.now}
  
  def self.take_dump
    file_handle = new_file_handle_name(".sql")
    cmd = "pg_dump garage > #{ENV['FILES_DIR']}/#{file_handle}"
    run(cmd)
    self.create({:file_handle => file_handle})
  end
  
end