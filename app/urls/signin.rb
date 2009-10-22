
get '/signin' do
  @layout_info = {'middle_panel' => 'signin/page'}
  erb :"body/structure"
end

post '/signin/process' do
  username = params[:username]
  session[:username] = User.with_username(username) ? username : nil
  redirect_home if session[:username]
end
