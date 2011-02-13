
get '/signin' do
  erb(:"/signin/page")
end

post '/signin/process' do
  monitor {
    username = params[:username]
    if (allow_login?(username, params[:password]))
      user = User.with_username(username)
      session[:username] = user ? username : nil
      user.increment_counter
    else
      raise "Please check the username and password you have provided"
    end
  }
end
