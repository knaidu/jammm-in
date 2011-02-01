class FileData < ActiveRecord::Base
  set_table_name "file_data"
  
  def self.gather(obj)
    filedata = find_by_file_handle_or_create(obj)
    data = parse(obj.file_handle)
    puts data.inspect
    filedata.append({
      :file_handle => obj.file_handle,
      :length => data[:length],
      :mode => data[:mode],
      :samplerate => data[:samplerate],
      :bitrate => data[:bitrate],
      :filesize => data[:filesize]
    })
    filedata.save
  end
  
  def self.parse(file_handle)
    path = "/home/jammmin/files/#{file_handle}"
    cmd = "python #{ENV["WEBSERVER_ROOT"]}/scripts/MP3Info.py #{path}"
    lines = run(cmd)
    data = {}
    lines.split("\n").each{|line|
      arr = line.split(":")
      data[arr[0].strip.to_sym] = arr[1].strip
    }
    data
  end
  
  def self.create_waveform(obj)
    filedata = find_by_file_handle_or_create(obj)
    path = "#{ENV['STORAGE_DIR']}/#{obj.file_handle}-waveform.png"
    file_path = fetch_local_file_path(obj)
    wav_path = file_path + ".wav"
    cmd = "sox #{file_path} #{wav_path}"
    run(cmd)
    cmd = "python #{ENV["WEBSERVER_ROOT"]}/scripts/wav2png/wav2png.py #{wav_path} -h 41 -w 700 -a #{path}"
    run(cmd)
    File.delete(wav_path)
    filedata.append({:waveform_path => path})
    filedata.save
  end
  
  def self.find_by_file_handle_or_create(obj)
    self.find_by_file_handle(obj.file_handle) || self.new 
  end
  
  def self.fetch(file_handle)
    self.find_by_file_handle file_handle
  end
  
  def waveform_url
    "/file/waveform/#{file_handle}?#{file_handle}"
  end
  
end