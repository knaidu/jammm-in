
get '/signup' do
  @layout_info = layout_info("signup")
  erb :"body/structure"
end

post '/signup/create' do
   if user = create_new_user(params['form'])
     set_session_user(user)
     redirect_home
   end
end
