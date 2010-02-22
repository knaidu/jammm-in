require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

cron_log_new_section("PUSH FILES TO S3")
Daemons.daemonize # Runs the script in the background

cron_log "Reading files to be pushed"

files_dir = ENV["FILES_DIR"]
cache_dir = ENV["CACHE_DIR"]
Dir.chdir(files_dir)

files = Dir.entries(files_dir).without(".").without("..")

files.each do |filename|
  full_file_path = "#{files_dir}/#{filename}"
  cron_log ("copying file #{full_file_path} to cache")
  File.copy(full_file_path, "#{cache_dir}/#{filename}")
  cron_log ("pushing file #{full_file_path}")
  S3.store_file(filename, File.open(full_file_path)) if not S3.exists?(filename)
  cron_log("deleting file #{full_file_path}")
  File.delete(full_file_path)
end

