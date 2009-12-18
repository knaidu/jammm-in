get '/account' do
  redirect_signin if not session[:username]
  redirect '/account/home'
end

get '/account/logout' do
  unset_session_user
  redirect '/'
end

get '/account/message_streams' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/message_streams"}  
  erb(:"account/structure")
end

get '/account/message_stream/:id' do
  @message_stream = MessageStream.find(params[:id])
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/message_stream"}  
  erb(:"account/structure")
end


get '/account/following' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/following"}  
  erb(:"account/structure")
end

get '/account/followers' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/followers"}  
  erb(:"account/structure")
end


get '/account/:section' do
  @layout_info = layout_info("account", params[:section])
  erb(:"account/structure") 
end
