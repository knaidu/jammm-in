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
  monitor {
    begin
      @tracks = session_user?.soundcloud_connect.public_tracks
      erb(:"/connect/soundcloud/choose_tracks")
    rescue
      raise "Something went wrong while trying to retrieve your tracks. Please try again soon."
    end
  }
end

get '/connect/soundcloud/is_connection_alive' do
  session_user?.soundcloud_connect.connection_alive?.to_json
end

get '/connect/soundcloud/import_tracks' do 
  monitor {
    tracks = param?(:tracks)
    session_user?.soundcloud_connect.import_tracks(tracks.split(",")).to_json
  }
end