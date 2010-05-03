get '/sessions/:name' do
  @layout_info = {"middle_panel" => "/sessions/#{param?(:name)}", "left_panel" => "homepage/left"}
  erb(:"body/structure")
end