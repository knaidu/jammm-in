
get '/jam/create' do
  manage_if_not_signed_in
  @layout_info = {"middle_panel" => 'jam/create'}
  erb(:"body/structure")
end

post '/jam/register' do
  name = params['name']
  jam = register_jam(session[:username], name)
  jam ? redirect_manage_jam(jam) : "false"
end


get '/jam/:jam_id/manage' do
  @layout_info = {'middle_panel' => 'jam/manage/page', 'right_panel' => 'jam/manage/instructions', 'left_panel' => 'account/menu'}
  @jam = Jam.find(params[:jam_id])
  erb(:"body/structure")
end


get '/jam/:jam_id/manage/upload' do
  @jam = Jam.find(params[:jam_id])
  erb(:"jam/manage/upload")
end

post '/jam/:jam_id/manage/upload_file' do
  file = params[:mefile][:tempfile]
  puts params[:mefile].inspect
  jam = Jam.find(params[:jam_id]).update_file(file)
  file.unlink
end

get '/jam/:jam_id/manage/tag_artist' do
  jam = get_passed_jam
  jam.tag_artist(User.with_username(params[:username]))
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
  get_passed_jam.publish ? "Jam successfully published" : "Jam could not be published"
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
  @layout_info = {"middle_panel" => 'jam/page', "right_panel" => 'jam/right'}
  @jam = Jam.find(params[:jam_id])
  @jam.visited
  erb(:"body/structure")
end


post '/jam/:jam_id/manage/update_information' do
  name = params[:name]
  desc = params[:desc]
  jam = Jam.find(params[:jam_id])
  ret = jam.update_information(name, desc)
  status 700 if not ret
  ret ? "Successfully updated JAM information" : "Failed to update JAM information"
end

get '/where/:who' do
  params[:who]

end
