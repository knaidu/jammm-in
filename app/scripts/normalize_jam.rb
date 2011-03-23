require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"

log_path = "/home/jammmin/log/sinatra.log"
log = File.new(log_path, "a+")
STDOUT.reopen(log)
STDERR.reopen(log)


jam_id = ARGV[0]
jam = Jam.find(jam_id)

# Converting into an MP3
mp3_filename = FILES_DIR + "/" + new_file_handle_name(".mp3")
cmd = "soundconverter #{fetch_local_file_path(jam)} #{mp3_filename}"
run(cmd)

# Converting into a 2 Channel WAV using sox
wav_filename = FILES_DIR + "/" + new_file_handle_name(".wav")
cmd = "sox #{mp3_filename} -c 2 #{wav_filename}"
run(cmd)

# Converting into a MP3 using lame
mp3_filename = FILES_DIR + "/" + new_file_handle_name
# Fixes the bitrate and the sampling rate
cmd = "lame #{wav_filename} -b 192 --resample 44.1 #{mp3_filename}"
run(cmd)
puts mp3_filename
jam.file_handle = mp3_filename.split("/").pop
jam.save