require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

cron_log_new_section("EMPTY FILES IF IN S3")
Daemons.daemonize # Runs the script in the background

cron_log "Reading files to be deleted"

files_dir = ENV["FILES_DIR"]
cache_dir = ENV["CACHE_DIR"]
storage_dir = ENV["STORAGE_DIR"]
Dir.chdir(files_dir)

files = Dir.entries(files_dir).without(".").without("..")

files.each do |filename|
  full_file_path = "#{files_dir}/#{filename}"
  if S3.exists?(filename)
    cron_log("Deleting ... #{filename}")
    File.delete(full_file_path)
  else
    cron_log("Skipping ... #{filename}")
  end
end
