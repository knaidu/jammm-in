
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
  @layout_info = {"left_panel" => "common/little_menu", "middle_panel" => 'song/page', "right_panel" => 'song/right'}
  @song = Song.find(params[:song_id])
  @song.visited
  erb(:"body/structure")
end

get '/song/:song_id/basic_info' do
  erb(:"song/basic_info", :locals => {:song => get_passed_song})
end

get '/song/:song_id/likes' do 
  erb(:"song/likes", :locals => {:song => get_passed_song})
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
  begin
    song = get_passed_song
    user = User.with_username(params[:username])
    "Successfully added user" if song.add_manager(user)
  rescue Exception => e
    render_error(e)
  end
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
  jams_arr = params[:jam_ids].split(',')
  jams = params[:jam_ids].split(',').map do |id| Jam.find(id) end
  song.publish(jams).to_json
end

get '/song/:song_id/manage/unpublish' do
  song = get_passed_song
  song.unpublish ? "Successfully removed song" : "Error in removing song"
end

get '/song/:song_id/manage/delete_song' do
  song = get_passed_song
  song.destroy ? "Successfully removed song" : "Error in removing song"
end

get '/song/:song_id/manage/like' do
  song = get_passed_song
  song.like(session_user) ? "Successfully liked song" : "Error in liking song"
end

get '/song/:song_id/manage/unlike' do
  song = get_passed_song
  song.unlike(session_user) ? "Successfully unliked song" : "Error in unliking song"
end

post '/song/:song_id/manage/add_lyrics' do
  song = get_passed_song
  song.add_lyrics(session_user, params[:lyrics]) ? "saved lyrics" : "could not save lyrics"
end
