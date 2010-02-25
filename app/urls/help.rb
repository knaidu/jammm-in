get '/help/tutorial' do
  @layout_info = {"left_panel" => 'homepage/left', 'middle_panel' => 'help/tutorial', 'right_panel' => "homepage/right"}
  erb(:"body/structure")
end

get '/help/faq' do
  @layout_info = {"left_panel" => 'homepage/left', 'middle_panel' => 'help/faq', 'right_panel' => "homepage/right"}
  erb(:"body/structure")
end


