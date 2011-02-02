
get '/jam/create' do
  erb(:"jam/create")
end

get '/jam/create_form' do
  erb(:"/jam/create_form")
end

post '/jam/create/submit' do
  file = params[:file][:tempfile]
  puts params[:file].inspect
  instrument = Instrument.find(param?(:instrument))
  jam = Jam.construct_jam(@session_user, param?(:name), instrument, param?(:file))
  puts jam.inspect
  @jam = jam
  erb(:"/jam/created")
end

get '/jam/context_menu' do
  @jam = get_passed_jam
  erb(:"/jam/context_menu")
end

post '/jam/register' do
  monitor {
    name = params['name']
    jam = JamUtils.register_jam(session[:username], name)
    puts jam.id
    jam.id.to_s
  }
end

get '/jam/:jam_id/basic_info' do
  erb(:"jam/basic_info", :locals => {:jam => get_passed_jam})
end

get '/jam/:jam_id/likes' do 
  erb(:"common/likes", :locals => {:artists => get_passed_jam.liked_by})
end

get '/jam/:jam_id/jam_picture' do
  monitor {
    send_file(get_passed_jam.jam_picture, {
      :filename => "jam_picutre",
      :disposistion => "inline"
    })
  }
end


get '/jam/:jam_id/manage' do
  @jam = get_passed_jam
  @music_meta_data = music_meta_data(@jam)
#  allowed?(@jam.artists) {
    erb(:"/jam/manage/page")
#  }
end

post '/jam/:jam_id/manage/change_jam_picture' do
#  monitor {
    file = param?(:picture)[:tempfile]
    puts file
    get_passed_jam.change_jam_picture(file)
    file.unlink
    redirect_path = "/partial/jam/manage/jam_picture_form?jam_id=#{param?(:jam_id)}"
    puts redirect_path
    redirect redirect_path
#  }
end

get '/jam/:jam_id/manage/update_file' do
  @jam = Jam.find(params[:jam_id])
  erb(:"jam/manage/upload")
end

get '/jam/:jam_id/manage/update_file_form' do
  @jam = Jam.find(params[:jam_id])
  erb(:"jam/manage/upload_form")
end

post '/jam/:jam_id/manage/update_file/submit' do
  file = params[:file][:tempfile]
  puts params[:mefile].inspect
  jam = Jam.find(params[:jam_id]).update_file(params[:file])
  file.unlink
  erb(:"jam/manage/uploaded")
end

post '/jam/:jam_id/manage/update_info' do
  monitor {
    get_passed_jam.update_info(param?(:key), param?(:value))
    "Successfully saved information"
  }
end

post '/jam/:jam_id/manage/update_instrument' do
  monitor {
    i = Instrument.find(param?(:value))
    get_passed_jam.update_instrument(i)
    "Successfully saved information"
  }
end

get '/jam/:jam_id/manage/tag_artist' do
  monitor {
    jam = get_passed_jam
    raise "User #{param?(:username)} does not exist." if not (user = User.with_username(params[:username]))
    jam.tag_artist(user)
    "Successfully tagged artist to this jam"
  }
end

get '/jam/:jam_id/manage/untag_artist' do
  jam = Jam.find(params[:jam_id])
  jam.untag_artist(User.find(params[:artist_id]))
end

get '/jam/:jam_id/manage/artists' do
  @jam = Jam.find(params[:jam_id])
  erb :'jam/manage/artists'
end

get '/jam/:jam_id/manage/file_actions' do
  @jam = Jam.find(params[:jam_id])
  erb :'jam/manage/file_actions'
end

get '/jam/:jam_id/manage/publish' do
  monitor {
    get_passed_jam.publish
    "Jam successfully published"
  }
end

get '/jam/:jam_id/manage/unpublish' do
  get_passed_jam.unpublish ? "Jam successfully unpublished" : "Jam could not be unpublished"
  erb(:"jam/manage/upload")
end

get '/jam/:jam_id/manage/delete_jam' do
  get_passed_jam.destroy ? "Jam successfully deleted" : "Jam could not be deleted"
end

# Loads a songs
get '/jam/:jam_id' do
  @layout_info = {"left_panel" => "common/little_menu", "middle_panel" => 'jam/page', "right_panel" => 'jam/right'}
  @jam = get_passed_jam
  @music_meta_data = music_meta_data(@jam)
  @jam.visited
  erb(:"jam/page")
end


post '/jam/:jam_id/manage/update_information' do
  name = params[:name]
  desc = params[:desc]
  jam = Jam.find(params[:jam_id])
  ret = jam.update_information(name, desc)
  status 700 if not ret
  ret ? "Successfully updated JAM information" : "Failed to update JAM information"
end

get '/jam/:jam_id/manage/like' do
  jam = get_passed_jam
  jam.like(session_user) ? "Successfully liked jam" : "Error in liking jam"
end


get '/jam/:jam_id/manage/unlike' do
  jam = get_passed_jam
  jam.unlike(session_user) ? "Successfully unliked jam" : "Error in unliking jam"
end

get '/jam/:jam_id/manage/sheet_music' do
  erb(:'/jam/manage/sheet_music/sheet_music', :locals => {:jam => get_passed_jam})
end

post '/jam/:jam_id/manage/add_sheet_music' do
  jam = get_passed_jam
#  monitor {
    file = param?(:file)[:tempfile]
    puts file
    jam.add_sheet_music(param?(:sheet_type), param?(:description), file)
    file.unlink
    redirect_path = "/partial/jam/manage/sheet_music/sheet_music_added"
    redirect redirect_path
#  }  
end

get '/jam/:jam_id/manage/delete_sheet_music' do
  monitor {
    SheetMusic.find(param?(:sheet_music_id)).destroy
    "Successfully deleted sheet music"
  }
end

post '/jam/:jam_id/manage/set_policy' do
  monitor {
    jam = get_passed_jam.set_policy param?(:policy)
  }
end
