class FileData < ActiveRecord::Base
  set_table_name "file_data"
  
  def self.gather(obj)
    filedata = self.find_by_file_handle(obj.file_handle) || self.new
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
  
end