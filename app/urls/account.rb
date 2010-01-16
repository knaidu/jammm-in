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

get '/account/aboutme/change_password' do
  monitor {
    password, confirm_password = get_params(:password, :confirm_password)
    raise "Passwords do not match" if password != confirm_password
    session_user?.change_password(password)
    "Your password has been successfully changed."
  }
end

get '/account/aboutme/save_basic_info' do
  monitor {
    name, location = get_params(:name, :location)
    session_user?.update_basic_info({:name => name, :location => location})
    "Information has been saved"
  }
end

post '/account/aboutme/change_profile_picture' do
#  monitor {
    file = param?(:picture)[:tempfile]
    puts "----------------"
    puts file
    session_user?.change_profile_picture(file)
    file.unlink
    redirect "/partial/account/aboutme/profile_picture_form"
 # }
end

get '/account/:section' do
  @layout_info = layout_info("account", params[:section])
  erb(:"account/structure") 
end
