get '/admin/site_counter' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "admin/site_counter"}
  erb(:'body/structure')
end

get '/admin/table/:table_name' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "admin/table"}
  table_name = param?(:table_name)
  @data = eval(table_name + ".all") rescue []
  erb(:'body/structure')
end


get '/admin/table/:table_name/:row_id' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "admin/table"}
  table_name = param?(:table_name)
  @data = [eval(table_name + ".find(param?(:row_id))")] rescue []
  erb(:'body/structure')
end

get '/admin/broadcast_message' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "admin/broadcast_message"}
  erb(:"body/structure")
end

post '/admin/broadcast_message/process' do
#  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "admin/broadcast_message"}
#  erb(:"body/structure")
  User.broadcast_message(param?(:message))
end