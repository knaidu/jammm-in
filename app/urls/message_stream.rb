
post '/message_stream/new_post' do
  user_1, user_2 = params[:user_ids].split(",").map do |id| User.find(id) end
  add_message(user_1, user_2, params[:body])
end

get '/message_stream/show' do
  user_1, user_2 = get_passed_users_by_id
  message_stream = MessageStream.find_stream(user_1, user_2)
  erb(:"common/message_stream", {:locals => {:message_stream => message_stream}})
end
