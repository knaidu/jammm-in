
# Loads a songs

get '/song/create' do
  @music_type, @music_id = param?(:music_type), param?(:music_id)
  @obj = eval(@music_type.capitalize).find(@music_id)
  erb(:"song/create")
end

post '/song/create/submit' do
  monitor {
    name = params['name']
    song = register_song(session[:username], name)
  
    # Registers a song and adds music to it.
    if add_music = param?(:add)
      puts "trying to register"
      music_type, music_id = get_params?(:music_type, :music_id)
      song.add_music(eval(music_type.capitalize), music_id, session_user?)
    end
    song.id.to_s
  }
end


get '/song/add_music' do
  logged_in? {
    @add = param?(:add)
    @layout_info = {'middle_panel' => 'song/add_music/page', 'left_panel' => 'account/menu'}
    erb(:"body/structure")
  }
end


get '/song/:song_id' do
  @song = Song.find(params[:song_id])
  @song.visited
  @music_meta_data = music_meta_data(@song)
  erb(:"song/page")
end

get '/song/:song_id/context_menu' do
  @song = get_passed_song
  erb(:"/song/context_menu")
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
  allowed?(@song.managers){
    @music_meta_data = music_meta_data(@song)
    erb(:"song/manage/page")
  }
end

get '/song/:song_id/manage/update_picture' do
  @song = get_passed_song
  allowed?(@song.artists){
    erb(:"/song/manage/update_picture")
  }
end

get '/song/:song_id/manage/update_picture_form' do
  @song = get_passed_song
  allowed?(@song.artists){
    erb(:"/song/manage/update_picture_form")
  }
end

post '/song/:song_id/manage/update_picture/submit' do
  monitor {
    file = param?(:picture)[:tempfile]
    puts file
    get_passed_song.change_song_picture(file)
    file.unlink
    erb(:"/song/manage/picture_updated")
  }
end

get '/song/:song_id/manage/jams' do
  @song = Song.find(params[:song_id])
  @jams = @song.jams
  erb(:"song/manage/jams")
end

post '/song/:song_id/manage/update_info' do
  monitor {
    get_passed_song.update_info(param?(:key), param?(:value))
    "Successfully saved information"
  }
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
  monitor {
    song = get_passed_song
    user = User.with_username(params[:username])
    raise "User #{params[:username]} does not exists" if user.nil?
    song.add_manager(user)
    song.send_invite_notification(user)
    "Successfully added user"
  }
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
  jams_arr = params[:jam_ids].split(';')
  song.save_song_jams_data(jams_arr)
  jams = params[:jam_ids].split(';').map{|arr| Jam.find(arr.split(",")[0])}
  song.flatten_jams(jams).to_json
end

post '/song/:song_id/manage/publish' do
  song = get_passed_song
  allowed?(song.artists){
    song.publish
    "Your song has been successfully published"
  }
end

post '/song/:song_id/manage/unpublish' do
  song = get_passed_song
  song.unpublish ? "Successfully removed song" : "Error in removing song"
end

post '/song/:song_id/manage/delete_song' do
  song = get_passed_song
  song.destroy ? "Successfully removed song" : "Error in removing song"
end

post '/song/:song_id/manage/like' do
  song = get_passed_song
  song.like(session_user) ? "Successfully liked song" : "Error in liking song"
end

post '/song/:song_id/manage/unlike' do
  song = get_passed_song
  song.unlike(session_user) ? "Successfully unliked song" : "Error in unliking song"
end

post '/song/:song_id/manage/add_lyrics' do
  song = get_passed_song
  song.add_lyrics(session_user, params[:lyrics]) ? "saved lyrics" : "could not save lyrics"
end


post '/song/:song_id/manage/post_message' do
  monitor {
    song = get_passed_song
    song.add_manage_message(session_user?, param?(:message))
    "Successfully added song message"
  }
end


get '/song/:song_id/manage/publish_popup' do
  @song = get_passed_song
  erb(:"/song/manage/publish_popup")
end

get '/song/:song_id/facebook_share' do
  @song = get_passed_song
  erb(:"/song/facebook_share")
end