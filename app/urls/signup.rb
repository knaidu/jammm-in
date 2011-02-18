
get '/signup' do
  erb :"signup/form"
end

post '/signup/create' do
  monitor {
    user = create_new_user(params['form'])
    set_session_user(user)
    "Successfully created user"
  }
end
