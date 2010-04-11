get '/chat' do
  logged_in? {
    session_user?.sign_in_chat
    @layout_info = {"left_panel" => "chat/left", "middle_panel" => "chat/page"}  
    erb(:"body/structure")
  }
end

get '/chat/sign_out' do
  session_user?.sign_out_chat
  "Successfully signed out of chat."
end

post '/chat/say' do
  monitor {
    message = param?(:message)
    session_user?.say_in_chat(message)
  }
end

get '/chat/ping' do
  chat_ping(session_user?).to_json
end

get '/chat/new_messages' do
  new_messages = session_user?.chat_user.new_messages?
  session_user?.pinged_chat
  erb(:"/chat/messages", :locals => {:messages => new_messages})
end