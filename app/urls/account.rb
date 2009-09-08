get '/account' do
  redirect '/account/home'
end

get '/account/:section' do
  begin
    @layout_info = layout_info("account", params[:section])
    erb(:"account/structure") 
  rescue
    redirect_home
  end
end
