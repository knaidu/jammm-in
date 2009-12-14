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

def new_file_handle_full_name
  ENV["FILES_DIR"] + "/" + new_file_handle_name
end



def mark_jams_as_active(song, jams)
  ids = jams.map(&:id)
  song.song_jams.each do |song_jam|
    ids.include?(song_jam.jam_id) ? song_jam.activate : song_jam.deactivate
  end
end

def delete_old_song_file_handle(song, jams)
  song.delete_file_handle if song.file_handle_exists?  
end

def arrage_jams_for_processing(jams)
  temp_arr = jams.clone
  temp_arr = temp_arr.split_at(1)
  temp_output = new_file_handle_full_name + ".wav"
  puts temp_arr[0][1]
  temp_arr[0].push(temp_output)
  temp_arr[0][0] = temp_arr[0][0].file.path
#  temp_arr[0] = temp_arr[0].in_groups_of(3)
  if temp_arr[1]
    temp_arr[1] = temp_arr[1].in_groups_of(1)
    temp_arr[1].map! {|arr|
      output = new_file_handle_full_name + ".wav"
      arr = [temp_output] + arr + [output]
      temp_output = output
      arr
    }
    temp_arr[1] = temp_arr[1].flatten
  end
  temp_arr
end

if jams.size == 1
  mark_jams_as_active(song, jams)
  delete_old_song_file_handle(song, jams)
  song.file_handle = jams[0].make_copy_of_file_handle(new_file_handle_full_name) if jams[0].file_handle_exists?
  song.save
  
  process_info.set_done "Song has been successfully published."
  exit
  
end

mark_jams_as_active(song, jams)
delete_old_song_file_handle(song, jams)
sox_output = false
lame_output = new_file_handle_full_name

# sox merging
process_info.set_message "Processing jams"

arranged_jams_info = arrage_jams_for_processing(jams)

arranged_jams_info.each { |info|
  process_info.set_message "Processing #{info[1].name}"
  cmd = "sox -m '#{info[0]}' '#{info[1].file.path}' '#{info[2]}'"
  run(cmd)
  sox_output = info[2]
}

# lame encoding
process_info.set_message "Encoding media into MP3"
cmd = "lame #{sox_output} #{lame_output}"
run(cmd)

song.file_handle = lame_output
song.save

process_info.set_done "Song has been successfully published."

puts [sox_output, lame_output].inspect
exit
