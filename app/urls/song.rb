
# Loads a songs

get '/song/create' do
  manage_if_not_signed_in
  @layout_info = {"middle_panel" => 'song/create'}
  erb(:"body/structure")
end

post '/song/register' do
  name = params['name']
  desc = params['description']
  register_song(session[:username], name, desc)
end

get '/song/:song_id' do
  @layout_info = {"middle_panel" => 'song/page', "right_panel" => 'song/right'}
  @song = Song.find(params[:song_id])
  @song.visited
  erb(:"body/structure")
end

get '/song/:song_id/manage' do
  @layout_info = {'middle_panel' => 'song/manage/page'}
  @song = Song.find(params[:song_id])
  erb(:"body/structure")
end

