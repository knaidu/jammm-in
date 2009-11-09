
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
  @layout_info = {'middle_panel' => 'song/manage/page', 'left_panel' => 'account/menu'}
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
  song.add_jam(get_passed_jam) ? "Successfully added JAM" : "Error in adding JAM"
end

get '/song/:song_id/manage/remove_jam' do
  song = get_passed_song
  jam = get_passed_jam
  song.remove_jam(jam) ? "Successfully removed JAM" : "Error in removing JAM"
end


get '/song/:song_id/manage/artists' do
  @song = get_passed_song
  @artists = @song.managers
  erb :'song/manage/artists'
end

get '/song/:song_id/manage/invite_artist' do
  song = get_passed_song
  user = User.with_username(params[:username])
  song.add_manager(user) ? "Successfully added user" : "Error in adding user"
end

get '/song/:song_id/manage/remove_artist' do
  song = get_passed_song
  artist = User.find(params[:artist_id])
  song.remove_artist(artist) ? "Successfully removed user" : "Error in removing user"
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


get '/song/:song_id/manage/publish' do
  song = get_passed_song
  jams = params[:jam_ids].split(',').map do |id| Jam.find(id) end
  song.publish(jams) ? "Successfully removed user" : "Error in removing user"
end