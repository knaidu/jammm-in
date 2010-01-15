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

get '/account/aboutme' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/aboutme/page"}  
  erb(:"account/structure")
end

get '/account/aboutme/save_basic_info' do
  monitor {
    name, location = get_params(:name, :location)
    session_user?.update_basic_info({:name => name, :location => location})
    "Information has been saved"
  }
end

get '/account/aboutme/add_genre' do
  monitor {
    genre_id = param?(:genre_id)
    session_user?.add_genre(Genre.find(genre_id))
  }
end

get '/account/:section' do
  @layout_info = layout_info("account", params[:section])
  erb(:"account/structure") 
end
