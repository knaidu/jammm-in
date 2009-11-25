require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

puts "Running script in the background"
Daemons.daemonize # Runs the script in the background

options = {}
ARGV.each do |arg|
  res = (/--(.+)=(.+)/ =~ arg)
  options[$1.to_sym] = $2 if res and $1 and $2
end

puts options.inspect

jams = options[:jams].split(',').map do |id| Jam.find(id.to_i) end
song = Song.find(options[:song])

if jams.empty?
  puts "No Jams provided."
  puts "Exiting..."
  exit
end

process_info = ProcessInfo.find_by_process_id(options[:process_id].to_i) || ProcessInfo.add(options[:process_id].to_i)
process_info.clear

process_info.set_message "Processing songs"

def file_path(file_handle)
  ENV["FILES_DIR"] + "/" + file_handle
end

if jams.size == 1
  puts "single jam"
  ids = jams.map(&:id)
  song.song_jams.each do |song_jam|
    ids.include?(song_jam.jam_id) ? song_jam.activate : song_jam.deactivate
  end
  song.delete_file_handle if song.file_handle_exists?
  song.file_handle = jams[0].make_copy_of_file_handle(new_file_handle_name) if jams[0].file_handle_exists?
  song.save
  
  process_info.set_done "Song has been successfully published."
  exit
  
end

sox_output = new_file_handle_name + ".wav"
lame_output = new_file_handle_name + ".mp3"

# sox merging
process_info.set_message "Flattening Jams"
cmd = "sox -m '#{jams[0].file.path}' '#{jams[1].file.path}' '#{file_path(sox_output)}'"
run(cmd)

# lame encoding
process_info.set_message "Encoding media into MP3"
cmd = "lame #{file_path(sox_output)} #{file_path(lame_output)}"
run(cmd)

song.file_handle = lame_output
song.save

process_info.set_done "Song has been successfully published."

puts [sox_output, lame_output].inspect
exit