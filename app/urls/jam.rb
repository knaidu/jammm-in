
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


post '/jam/uploadmp3' do
  puts 'good........'
#  sleep 3
  puts 'morning...........'
  file = params[:mefile][:tempfile]
  puts params[:mefile].inspect
  puts 'file path: ' + file.path
  puts file.class
#  params[:mefile][:tempfile].methods.sort.join(", ")
#  file.path
end

# Loads a songs
get '/jam/:jam_id' do
  @layout_info = {"middle_panel" => 'jam/page', "right_panel" => 'jam/right'}
  @jam = Jam.find(params[:jam_id])
  @jam.visited
  erb(:"body/structure")
end


get '/jam/:jam_id/manage' do
  @layout_info = {'middle_panel' => 'jam/manage/page', 'right_panel' => 'jam/manage/instructions'}
  @jam = Jam.find(params[:jam_id])
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
