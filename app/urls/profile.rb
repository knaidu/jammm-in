# Loads the user profile page
get '/:username' do 
  begin
    @layout_info = layout_info("profile")
    @user_id = 112
    erb(:"profile/structure")
  rescue Exception => e
    redirect_home
  end
end

# Loads eg: jammm.in/user1/songs. 
# :section => [songs, jams, bands]
get '/:username/:section' do
  sections = subsections('profile')
  begin
    raise "Section: #{params[:section]} not found" if not sections.include?(params[:section])
    @layout_info = layout_info("profile", params[:section])
    @data = TestTable.find(:all)
    erb(:"profile/structure")
  rescue Exception => e
    puts e.inspect
    show_profile(params[:username])
  end
end
