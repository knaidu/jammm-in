
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
  file = params[:mefile][:tempfile]
  puts file.methods.sort
  params[:mefile].inspect
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
  @layout_info = {'middle_panel' => 'jam/manage/page'}
  @jam = Jam.find(params[:jam_id])
  erb(:"body/structure")
end