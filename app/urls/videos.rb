get '/videos' do
  cmd = "ls " + APP_ROOT + "/views/help/videos"
  @vids = run(cmd).split("\n").map{|vid| vid.split(".")[0]}.without "index"
  @layout_info = {"middle_panel" => 'help/videos/index', 'left_panel' => 'homepage/left', "right_panel" => "homepage/right"}
  erb(:"body/structure")
end

get '/videos/:vid' do
  @layout_info = {"middle_panel" => "/help/videos/#{param?(:vid)}", 'left_panel' => 'homepage/left', "right_panel" => "homepage/right"}
  erb(:"body/structure")
end