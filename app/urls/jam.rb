
get '/jam/create' do
  manage_if_not_signed_in
  @layout_info = {"middle_panel" => 'jam/create'}
  erb(:"body/structure")
end

post '/jam/register' do
  name = params['name']
  desc = params['description']
  register_jam(session[:username], name, desc)
end

# Loads a songs
get '/jam/:jam_id' do
  @layout_info = {"middle_panel" => 'jam/page', "right_panel" => 'jam/right'}
  @jam = Jam.find(params[:jam_id])
  erb(:"body/structure")
end
