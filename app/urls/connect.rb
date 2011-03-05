# This file contains 
# soundcloud connect

get '/connect/soundcloud/connect' do
  redirect SoundCloudConnect.connect_url
end

get '/connect/soundcloud/connect/intro' do
  erb(:"/connect/soundcloud/intro")
end

get '/connect/soundcloud/request_token' do
  param?(:code)
end

get '/connect/soundcloud/request_token' do
  redirect '/soundcloud/request_token?code=#{param?(:code)}'
end