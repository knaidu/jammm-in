
get '/signin' do
  @layout_info = {'middle_panel' => 'signin/page', "left_panel" => "homepage/left", "right_panel" => "homepage/right"}
  erb :"body/structure"
end

post '/signin/process' do
  username = params[:username]
  if (allow_login?(username, params[:password]))
    user = User.with_username(username)
    session[:username] = user ? username : nil
    user.increment_counter
    redirect_home if session[:username]
  else
    redirect '/signin'
  end
end
