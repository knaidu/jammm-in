get '/search' do
  key = param?(:q) or param?(:key)
  @found = search_with_key(key) rescue "[]"
  left_panel = session_user? ? "account/menu" : "homepage/menu"
  @layout_info = {"middle_panel" => 'search/page', 'left_panel' => 'homepage/left'}
  erb(:"body/structure")
end
