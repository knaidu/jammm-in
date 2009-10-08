
# Loads the user profile page 
get '/:username' do
  begin
    user = params[:username]
    is_user = User.find_by_username(user)
    @layout_info = is_user ? layout_info("profile") : layout_info("profile", "usernotfound")
    @menu_data = profile_home_info(user) if is_user
    erb(:"profile/structure")
  rescue Exception => e
    puts e.inspect
    redirect_home
  end
end


get '/:username/songs' do
  @layout_info = layout_info("profile", 'songs')
  @menu_data = profile_home_info(params[:username])
  @songs = User.with_username(params[:username]).songs rescue []
  erb(:"body/structure")
end


get '/:username/jams' do
  @layout_info = layout_info("profile", 'jams')
  @menu_data = profile_home_info(params[:username])
  erb(:"body/structure")
end


get '/:username/info' do
  @layout_info = {
    'left_panel' => 'profile/menu',
    "middle_panel" => 'profile/info'
  }
  @menu_data = profile_home_info(params[:username])
  erb(:"body/structure")
end


# For sections that are not found
get '/:username/:section' do
  @data = profile_home_info(params[:username])
  @layout_info = {
    'left_panel' => 'profile/menu',
    "middle_panel" => 'profile/section_not_found'
  }
  erb :"body/structure"
end
