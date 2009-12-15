get '/account' do
  redirect_signin if not session[:username]
  redirect '/account/home'
end

get '/account/logout' do
  unset_session_user
  redirect '/'
end

get '/account/:section' do
  @layout_info = layout_info("account", params[:section])
  erb(:"account/structure") 
end
