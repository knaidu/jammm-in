
# Loads a songs

get '/song/create' do
  manage_if_not_signed_in
  @layout_info = {"middle_panel" => 'song/create', 'left_panel' => 'account/menu'}
  erb(:"body/structure")
end

post '/song/register' do
  name = params['name']
  song = register_song(session[:username], name)
  song ? redirect_manage_song(song) : "false"
end

get '/song/:song_id' do
  @layout_info = {"middle_panel" => 'song/page', "right_panel" => 'song/right'}
  @song = Song.find(params[:song_id])
  @song.visited
  erb(:"body/structure")
end

get '/song/:song_id/manage' do
  @layout_info = {'middle_panel' => 'song/manage/page'}
  @song = Song.find(params[:song_id])
  erb(:"body/structure")
end

get '/song/:song_id/manage/jams' do
  @song = Song.find(params[:song_id])
  @jams = @song.jams
  erb(:"song/manage/jams")
end


get '/song/:song_id/manage/add_jam' do
  song = get_passed_song
  jam = Jam.find(params[:jam_id])
  song.add_jam(jam.id) ? "Successfully added JAM" : "Error in adding JAM"
end


post '/song/:song_id/manage/update_information' do
  name = params[:name]
  desc = params[:desc]
  song = Song.find(params[:song_id])
  puts "song is: #{song.name}"
  ret = song.update_information(name, desc)
  status 700 if not ret
  ret ? "Successfully updated song information" : "Failed to update song information"
end
