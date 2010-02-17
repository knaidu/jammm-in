get '/account' do
  redirect_signin if not session[:username]
  redirect '/account/home'
end

get '/account/logout' do
  unset_session_user
  redirect '/'
end


get '/account/messages' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/messages"}  
  erb(:"body/structure")
end

get '/account/mark_song_messages_as_read' do
  monitor {
    session_user?.set_last_read_song_messages_to_now
    "Marked all messages as read"
  }
end

get '/account/message_stream/:id' do
  @message_stream = MessageStream.find(params[:id])
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/message_stream"}  
  erb(:"body/structure")
end


get '/account/following' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/following"}  
  erb(:"body/structure")
end

get '/account/followers' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/followers"}  
  erb(:"body/structure")
end

get '/account/aboutme' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/aboutme/page"}  
  erb(:"body/structure")
end

get '/account/invite' do
  monitor {
    session_user?.invite(param?(:email))
    "Success. The invitation will be delivered in 30 minutes."
  }
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
  monitor {
    file = param?(:picture)[:tempfile]
    puts file
    session_user?.change_profile_picture(file)
    file.unlink
    redirect "/partial/account/aboutme/profile_picture_form"
  }
end

get '/account/notifications' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/notifications/page"}  
  erb(:"body/structure")
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

get '/account/:section' do
  @layout_info = layout_info("account", params[:section])
  erb(:"body/structure") 
end
