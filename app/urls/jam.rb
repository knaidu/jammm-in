
# Loads a songs

get '/jam/:jam_id' do
  @layout_info = {"middle_panel" => 'jam/page', "right_panel" => 'jam/right'}
  @jam = Jam.find(params[:jam_id])
  erb(:"body/structure")
end
