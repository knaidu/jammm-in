
# Loads a songs

get '/song/:song_id' do
  @layout_info = {"middle_panel" => 'song/page', "right_panel" => 'song/right'}
  @song = Song.find(params[:song_id])
  erb(:"body/structure")
end
