get '/account/home' do
  erb(:"/account/home")
end

get '/account' do
  redirect_signin if not session[:username]
  redirect '/account/home'
end

get '/account/logout' do
  unset_session_user
  redirect '/'
end


get '/account/messages' do
  logged_in? {
    erb(:"/account/messages")
  }
end

get '/account/mark_song_messages_as_read' do
  monitor {
    session_user?.set_last_read_song_messages_to_now
    "Marked all messages as read"
  }
end

get '/account/message_stream/:id' do
  @message_stream = MessageStream.find(params[:id])
  allowed?(@message_stream.users) {
    erb(:"/account/message_stream")
  }
end

get '/account/jams' do
  @jams = session_user?.jams
  erb(:"/account/jams")
end

get '/account/following' do
  logged_in? {
    @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/following"}  
    erb(:"body/structure")
  }
end

get '/account/followers' do
  logged_in? {
    @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/followers"}  
    erb(:"body/structure")
  }
end

get '/account/aboutme' do
  logged_in? {
    erb(:"/account/aboutme/page")
  }
end

get '/account/invite' do
  monitor {
    session_user?.invite(param?(:email))
    "Success. The invitation will be delivered in 30 minutes."
  }
end

post '/account/update_info' do
  monitor {
    session_user?.update_info(param?(:key), param?(:value))
    "Successfully saved information"
  }
end

post '/account/aboutme/change_password' do
  monitor {
    current_password, password, confirm_password = get_params(:current_password, :password, :confirm_password)
    raise "The your current password does not match the one in our system" if not session_user?.is_password?(current_password)
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

get '/account/aboutme/update_picture' do
  erb(:"/account/aboutme/update_picture")
end

get '/account/aboutme/update_picture/form' do
  erb(:"/account/aboutme/update_picture_form")
end

post '/account/aboutme/update_picture/submit' do
  monitor {
    file = param?(:picture)[:tempfile]
    puts file
    session_user?.change_profile_picture(file)
    file.unlink
    erb(:"/account/aboutme/picture_updated")
  }
end

get '/account/notifications' do
  logged_in? {
    erb(:"account/notifications/page")
  }
end

get '/account/update_share_policy' do
  monitor {
    site = param?(:site)
    policy = param?(:policy)
    puts policy
    session_user?.update_share_policy(site, policy)
    "Your new policy has been set successfully"
  }
end

post '/account/say' do
  monitor {
    message = param?(:message)
    session_user?.say(message)
  }
end

get '/account/:section' do
  logged_in? {
    @layout_info = layout_info("account", params[:section])
    erb(:"body/structure") 
  }
end
