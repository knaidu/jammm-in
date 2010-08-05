get '/schools/:handle' do
  school_exists?{
    @layout_info = {"middle_panel" => 'schools/middle', "left_panel" => "schools/left", "right_panel" => "schools/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/jams' do
  @layout_info = {"middle_panel" => 'schools/jams', "left_panel" => "schools/left", "right_panel" => "schools/right"}
  erb(:"body/structure")
end

get '/schools/:handle/songs' do
  @layout_info = {"middle_panel" => 'schools/songs', "left_panel" => "schools/left", "right_panel" => "schools/right"}
  erb(:"body/structure")
end

get '/schools/:handle/admin' do
  @layout_info = {"middle_panel" => 'schools/admin', "left_panel" => "schools/left", "right_panel" => "schools/right"}
  erb(:"body/structure")
end

