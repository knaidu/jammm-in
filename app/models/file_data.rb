class FileData < ActiveRecord::Base
  set_table_name "file_data"
  
  def self.gather(obj, flattened_file=false)
    filedata = find_by_file_handle_or_create(obj, flattened_file)
    file_handle = flattened_file ? obj.flattened_file_handle : obj.file_handle
    path = flattened_file ? ENV["FILES_DIR"] + "/" + obj.flattened_file_handle : fetch_local_file_path(obj)
    data = parse(path)
    puts data.inspect
    filedata.append({
      :file_handle => file_handle,
      :length => data[:length],
      :mode => data[:mode],
      :samplerate => data[:samplerate],
      :bitrate => data[:bitrate],
      :filesize => data[:filesize]
    })
    filedata.save
  end
  
  def self.parse(path)
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
    path_2 = "#{ENV['STORAGE_DIR']}/#{obj.file_handle}-waveform-2.png"
    file_path = fetch_local_file_path(obj)
    wav_path = file_path + ".wav"
    cmd = "sox #{file_path} #{wav_path}"
    run(cmd)
    
    # contructs the first waveform
    cmd = waveform_cmd(wav_path, path, 255, 255, 255)
    run(cmd)
    filedata.append({:waveform_path => path})

    # contructs the second waveform    
    cmd = waveform_cmd(wav_path, path_2, 231, 231, 231)
    run(cmd)
    filedata.append({:waveform_path_2 => path_2})
    filedata.save
    
    File.delete(wav_path)
    puts filedata.inspect
    filedata
  end
  
  def self.waveform_cmd(wav_path, path, r,g,b)
    puts "Creating waveform at: #{path}"
    "python #{ENV["WEBSERVER_ROOT"]}/scripts/wav2png/wav2png.py #{wav_path} -h 41 -w 700 -a #{path} -r #{r} -g #{g} -b #{b}"
  end
  
  def self.find_by_file_handle_or_create(obj, flattened_file=false)
    file_handle = flattened_file ? obj.flattened_file_handle : obj.file_handle
    filedata = self.find_by_file_handle(file_handle) || self.new 
    filedata.file_handle = obj.file_handle
    filedata
  end
  
  def self.fetch(file_handle)
    self.find_by_file_handle file_handle
  end
  
  def waveform_url
    "/file/waveform/#{file_handle}?#{file_handle}"
  end
  
  def waveform_url_2
    "/file/waveform2/#{file_handle}?#{file_handle}"
  end
  
end