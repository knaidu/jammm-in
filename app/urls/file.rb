
get "/file/:file_handle" do

  file_handle = param?(:file_handle)
  
  if S3.exists?(file_handle, S3::FILES_BUCKET)
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
