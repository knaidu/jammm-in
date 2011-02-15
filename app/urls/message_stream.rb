
post '/message_stream/new_post' do
  monitor {
    user_1, user_2 = params[:user_ids].split(",").map do |id| User.find(id) end
    if user_2 == session_user?
      user_1, user_2 = user_2, user_1
    end
    ret = add_message(user_1, user_2, params[:body])
    ret.to_json
  }
end

get '/message_stream/show' do
  user_1, user_2 = get_passed_users_by_id
  message_stream = MessageStream.find_stream(user_1, user_2)
  full = param?(:full).to_bool
  puts full.class
  erb(:"common/message_stream", {:locals => {:message_stream => message_stream, :full => full}})
end


get '/message_stream/mark_as_read' do
  begin
    user_1, user_2 = get_passed_users_by_id
    message_stream = MessageStream.find_stream(user_1, user_2)
    message_stream.mark_as_read(session_user?)
    "Successfully marked as read"
  rescue Exception => e
    puts e.message
    status 500
    e.message
  end
end


get '/message_stream/message' do
  message = UserMessageStream.find(param?(:id))
  erb(:"/common/message", :locals => {:message => message})
end