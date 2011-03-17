require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

log_path = "/home/jammmin/log/sinatra.log"
log = File.new(log_path, "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

puts "Running script in the background"
Daemons.daemonize # Runs the script in the background

options = {}
ARGV.each do |arg|
  res = (/--(.+)=(.+)/ =~ arg)
  options[$1.to_sym] = $2 if res and $1 and $2
end

puts options.inspect

$user = User.find options[:user_id]

$process_info = ProcessInfo.find_by_process_id(options[:process_id].to_i) || ProcessInfo.add(options[:process_id].to_i)
$process_info.clear

$process_info.set_message "Please wait while your tracks are being imported from your SoundCloud account ..."

def new_file_handle_full_name(ext=nil)
  ENV["FILES_DIR"] + "/" + new_file_handle_name(ext)
end

def import_track(track)
  $process_info.set_message "Importing track '#{track["title"]}'"
  output_file = new_file_handle_full_name(".mp3")
  $user.soundcloud_connect.download_track(track, output_file)
  file_details = {:tempfile => File.open(output_file), :filename => output_file.split("/").pop}
  title = track['title'].gsub(/[^#{DATA['allowed_name_chars']}]/i, "-")
  log "Creating Jam with name: #{title}"
  jam = Jam.construct_jam($user, title, nil, nil, nil, file_details)
  jam.publish
  log "track imported"
  sc = $user.soundcloud_connect
  sc.imports_remaining -= 1
  sc.save
end

tracks = $user.soundcloud_connect.fetch_tracks(options[:tracks].split(",").map(&:to_i))
puts tracks.inspect

tracks.each {|track|
  import_track(track)
}

$process_info.set_done "Your tracks have been successfully imported."