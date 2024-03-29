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

jams = options[:jams].split(',').map do |id| Jam.find(id.to_i) end
song = Song.find(options[:song])

if jams.empty?
  puts "No Jams provided."
  puts "Exiting..."
  exit
end

process_info = ProcessInfo.find_by_process_id(options[:process_id].to_i) || ProcessInfo.add(options[:process_id].to_i)
process_info.clear

process_info.set_message "Please wait while your jams are being mixed and processed ..."

def new_file_handle_full_name(ext=nil)
  ENV["FILES_DIR"] + "/" + new_file_handle_name(ext)
end

def mark_jams_as_flattened(song, jams)
  ids = jams.map(&:id)
  song.song_jams.each do |song_jam|
    ids.include?(song_jam.jam_id) ? song_jam.flattened : song_jam.flattened(false)
  end
end

def delete_old_song_file_handle(song, jams)
  song.delete_flattened_file_handle if song.flattened_file_handle_exists?  
end

def create_temp_waveform(song, wav_path)
  fd = song.flattened_file_data
  path = new_file_handle_full_name('.png')
  cmd = FileData.waveform_cmd(wav_path, path, 255, 255, 255)
  run(cmd)
  fd.waveform_path = path
  fd.save
  puts fd.inspect
  FileData.gather(song, true)
  puts song.flattened_file_data.inspect
end

if jams.size == 1
  process_info.set_message "Copying the Jam into the song..."
  delete_old_song_file_handle(song, jams)
  jam_file_handle = fetch_local_file_path(jams[0])
  song_flattened_file_handle = new_file_handle_full_name(".mp3")
  File.copy(jam_file_handle, song_flattened_file_handle)
  puts "song_flattened_file_handle: #{song_flattened_file_handle}"
  song.flattened_file_handle = song_flattened_file_handle.split("/").pop
  song.save
  mark_jams_as_flattened(song, jams)  
  process_info.set_done "Song has been successfully created."
  temp_wav_path = new_file_handle_full_name(".wav")
  cmd = "sox #{song_flattened_file_handle} #{temp_wav_path}"
  run(cmd)
  create_temp_waveform(song, temp_wav_path)
  File.delete(temp_wav_path)
  exit  
end

# NEW CODE
def construct_cmd(jams, wav_output_file_handle)
  jams_str = jams.map{|jam|
    "-v #{jam.song_jam.volume} #{fetch_local_file_path(jam)}"
  }
  ["sox", "-m", jams_str, wav_output_file_handle].flatten.join(" ")
end

def encode_to_mp3(input_file, output_file)
  run "lame #{input_file} #{output_file}"
end

delete_old_song_file_handle(song, jams)
sox_output = false
lame_output = new_file_handle_full_name(".mp3")
wav_output_file_handle = new_file_handle_full_name(".wav")

cmd = construct_cmd(jams, wav_output_file_handle)
puts cmd

run(cmd)
encode_to_mp3(wav_output_file_handle, lame_output)
mark_jams_as_flattened(song, jams)
song.flattened_file_handle = lame_output.split("/").pop
song.save

create_temp_waveform(song, wav_output_file_handle)

process_info.set_done "Song has been successfully flattened."