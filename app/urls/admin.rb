get '/admin/site_counter' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "admin/site_counter"}
  erb(:'body/structure')
end
