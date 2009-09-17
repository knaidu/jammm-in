get '/:username' do 
  begin
    @layout_info = layout_info("profile", params[:section])
    erb(:"profile/structure")
  rescue 
    redirect_home
  end
end

# Loads eg: jammm.in/user1/songs. 
# :section => [songs, jams, bands]
get '/:username/:section' do
  begin
    
  rescue 
    redirect '/:username'
  end
end