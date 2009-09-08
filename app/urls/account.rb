get '/account' do
  redirect '/account/home'
end

get '/account/:section' do
  erb(:"account/#{params[:section]}", :layout => :'layouts/layout_account') rescue redirect_home
end
