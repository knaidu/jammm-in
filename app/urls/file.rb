
get "/file/:file_handle" do

  file_handle = param?(:file_handle)
  increment_music_counter(file_handle) rescue nil
  
  if false and S3.exists?(file_handle, S3::FILES_BUCKET)
    path = S3.url_for_key(file_handle)
    redirect path
  else
    send_file(FILES_DIR + "/" + params[:file_handle], {
      :stream => false,
      :filename => "file.mp3",
      :type => "audio/mpeg"
    })
  end

end
  

get "/file/waveform/:file_handle" do
  puts "FILE HANDLE: #{param?(:file_handle)}"
  file_data = FileData.fetch(param?(:file_handle))
  puts "FILE #{file_data.inspect}"
  send_file(file_data.waveform_path)
end

get "/file/waveform2/:file_handle" do
  file_data = FileData.fetch(param?(:file_handle))
  send_file(file_data.waveform_path_2)
end