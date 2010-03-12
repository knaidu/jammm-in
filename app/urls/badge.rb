get '/badges' do
  @layout_info = {"middle_panel" => 'badges/page', 'left_panel' => 'homepage/left', 'right_panel' => "homepage/right"}
  erb(:"body/structure")
end
