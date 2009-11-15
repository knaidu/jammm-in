get '/account' do
  redirect_signin if not session[:username]
  redirect '/account/home'
end

get '/account/messages' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/messages"}
  erb(:'body/structure')
end

get '/account/messages/new' do
  @layout_info = {"left_panel" => "account/menu", "middle_panel" => "account/new_message"}
  erb(:'body/structure')
end

post '/account/messages/send' do
  to = User.with_username(params[:to])
  subject, body = get_params(:subject, :body)
  Message.add(session_user, to, subject, body)
end

get '/account/messages/delete' do
  ids = params[:ids].split(',')
  ids.each do |id| Message.find(id).destroy end
end

get '/account/logout' do
  session[:user] = nil
  redirect '/'
end

get '/account/:section' do
  @layout_info = layout_info("account", params[:section])
  erb(:"account/structure") 
end
