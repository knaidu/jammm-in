
get '/signup' do
  @layout_info = layout_info("signup")
  erb :"body/structure"
end

post '/signup/create' do
  begin
   if user = create_new_user(params['form'])
     set_session_user(user)
     redirect "/account/aboutme"
   end
 rescue Exception => e
   puts e.message
#   redirect '/signup'
 end
end
