
get '/signup' do
  @layout_info = layout_info("signup")
  erb :"body/structure"
end

post '/signup/create' do
   create_new_user(params['form'])
end
