
# Loads a songs

get '/song/:song_id' do
  @layout_info = {"middle_panel" => 'song/page'}
  erb(:"body/structure")
end
