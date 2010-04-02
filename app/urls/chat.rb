get '/chat' do
  logged_in? {
    session_user?.sign_in_chat
    @layout_info = {"left_panel" => "chat/left", "middle_panel" => "chat/page"}  
    erb(:"body/structure")
  }
end

get '/chat/sign_out' do
  session_user?.sign_out_chat
end

post '/chat/say' do
  monitor {
    message = param?(:message)
    session_user?.say_in_chat(message)
  }
end