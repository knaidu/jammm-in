
post '/message_stream/new_post' do
  user_1, user_2 = params[:user_ids].split(",").map do |id| User.find(id) end
  if user_2 == session_user?
    user_1, user_2 = user_2, user_1
  end
  add_message(user_1, user_2, params[:body])
end

get '/message_stream/show' do
  user_1, user_2 = get_passed_users_by_id
  message_stream = MessageStream.find_stream(user_1, user_2)
  full = param?(:full)
  erb(:"common/message_stream", {:locals => {:message_stream => message_stream, :full => full}})
end
