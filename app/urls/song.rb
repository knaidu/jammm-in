
# Loads a songs

get '/song/create' do
  manage_if_not_signed_in
  @layout_info = {"middle_panel" => 'song/create', 'left_panel' => 'account/menu'}
  erb(:"body/structure")
end

post '/song/register' do
  name = params['name']
  song = register_song(session[:username], name)
  
  # Registers a song and adds music to it.
  if add_music = param?(:add)
    music_type, music_id = get_add_music_info
    song.add_music(music_type, music_id)
  end
  song ? redirect_manage_song(song) : "false"
end

get '/song/add_music' do
  @add = param?(:add)
  @layout_info = {'middle_panel' => 'song/add_music/page', 'left_panel' => 'account/menu'}
  erb(:"body/structure")
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

get '/song/:song_id/add_music' do
  begin
    add = param?(:add)
    song = get_passed_song
    music_type, music_id = get_add_music_info
    "Successfully added music to song" if song.add_music(music_type, music_id)
  rescue Exception => e
    render_error(e)
  end
end

get '/song/:song_id/song_picture' do
  monitor {
    send_file(get_passed_song.song_picture, {
      :filename => "song_picutre",
      :disposistion => "inline"
    })
  }
end

get '/song/:song_id/manage' do
  @song = get_passed_song
  allowed?(@song.managers) {
    @layout_info = {'middle_panel' => 'song/manage/page', 'left_panel' => 'account/menu', 'right_panel' => 'song/manage/right'}
    erb(:"body/structure")
  }
end

post '/song/:song_id/manage/change_song_picture' do
#  monitor {
    file = param?(:picture)[:tempfile]
    puts file
    get_passed_song.change_song_picture(file)
    file.unlink
    redirect_path = "/partial/song/manage/song_picture_form?song_id=#{param?(:song_id)}"
    redirect redirect_path
#  }
end

get '/song/:song_id/manage/jams' do
  @song = Song.find(params[:song_id])
  @jams = @song.jams
  erb(:"song/manage/jams")
end


get '/song/:song_id/manage/add_jam' do
  monitor {
    song = get_passed_song
    song.add_jam(get_passed_jam)
    "Successfully added JAM"
  }
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
    raise "User #{params[:username]} does not exists" if user.nil?
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


get '/song/:song_id/manage/flatten' do
  song = get_passed_song
  jams_arr = params[:jam_ids].split(',')
  jams = params[:jam_ids].split(',').map do |id| Jam.find(id) end
  song.flatten_jams(jams).to_json
end

get '/song/:song_id/manage/publish' do
  song = get_passed_song
  song.publish
  "Your song has been successfully published"
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
