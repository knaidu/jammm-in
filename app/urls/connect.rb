# This file contains 
# soundcloud connect

get '/connect/soundcloud/connect' do
  puts SoundCloudConnect.connect_url
  redirect SoundCloudConnect.connect_url
end

get '/connect/soundcloud/connect/intro' do
  erb(:"/connect/soundcloud/intro")
end

get '/connect/soundcloud/request_token' do
  sc = session_user?.soundcloud_connect
  sc.save_tokens(param?(:code))
  erb(:"/connect/soundcloud/connected")
end

get '/connect/soundcloud/request_token' do
  redirect '/soundcloud/request_token?code=#{param?(:code)}'
end

get '/connect/soundcloud/choose_tracks' do
  @tracks = session_user?.soundcloud_connect.public_tracks
  erb(:"/connect/soundcloud/choose_tracks")
end

get '/connect/soundcloud/is_connection_alive' do
  (Time.now < session_user?.soundcloud_connect.expires_at).to_json
end