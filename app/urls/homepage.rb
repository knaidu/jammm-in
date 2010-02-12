get '/songs' do
  @layout_info = {"middle_panel" => 'homepage/songs', 'left_panel' => 'homepage/left'}
  erb(:"body/structure")
end

get '/jams' do
  @layout_info = {"middle_panel" => 'homepage/jams', 'left_panel' => 'homepage/left'}
  erb(:"body/structure")
end