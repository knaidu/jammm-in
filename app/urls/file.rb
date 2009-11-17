
get "/file/:file_handle" do
  send_file(FILES_DIR + "/" + params[:file_handle], {
    :stream => false,
    :filename => "file.mp3",
    :type => "audio/mpeg  "
  })
end