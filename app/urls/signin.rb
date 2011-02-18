
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


get '/signin/forgot_password' do
  erb(:"/signin/forgot_password")
end

post '/signin/forgot_password/submit' do
  monitor{
    email = param?(:email)
    user = User.find_by_email(email)
    raise "The email address is not registered to any account." unless user
    user.reset_password
    "Successfully set temporary password"
  }
end