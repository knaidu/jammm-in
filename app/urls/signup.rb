
get '/signup' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "signup/form"}
  erb :"body/structure"
end

post '/signup/create' do
  monitor {
    user = create_new_user(params['form'])
    set_session_user(user)
    "Successfully created user"
  }
end
