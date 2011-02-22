get '/help/tutorial' do
  @layout_info = {"left_panel" => 'homepage/left', 'middle_panel' => 'help/tutorial', 'right_panel' => "homepage/right"}
  erb(:"body/structure")
end

get '/help/faq' do
  erb(:"help/faq")
end


