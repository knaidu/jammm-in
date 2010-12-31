
# Loads the user profile page 
get '/:username' do
  user = params[:username]
  is_user = User.find_by_username(user)
  @layout_info = is_user ? layout_info("profile") : layout_info("profile", "usernotfound")
  if is_user
    @menu_data = profile_home_info(user) 
  else
    @layout_info["left_panel"] = "/homepage/left"
  end
  set_profile_page_info user
  erb(:"body/structure")
end


get '/:username/songs' do
  @user = User.with_username(params[:username])
  @layout_info = layout_info("profile", 'songs')
  @menu_data = profile_home_info(params[:username])
  @songs = @user.published_songs rescue []
  erb(:"body/structure")
end


get '/:username/jams' do
  user = params[:username]
  @layout_info = layout_info("profile", 'jams')
  @menu_data = profile_home_info(user)
  set_profile_page_info user
  erb(:"body/structure")
end

get '/:username/followers' do
  user = params[:username]
  @layout_info = {"left_panel" => "profile/menu", "middle_panel" => "profile/followers"}
  @menu_data = profile_home_info(user)
  set_profile_page_info user
  erb(:"body/structure")
end

get '/:username/following' do
  user = params[:username]
  @layout_info = {"left_panel" => "profile/menu", "middle_panel" => "profile/following"}
  @menu_data = profile_home_info(user)
  set_profile_page_info user
  erb(:"body/structure")
end

get '/:username/follow' do
  begin
    Follower.add(session_user?, get_passed_user)
    "You are following #{get_passed_user.name}"
  rescue Exception => e
    status 500
    e.message
  end
end

get '/:username/collaborators' do
  @layout_info = {"left_panel" => "profile/menu", "middle_panel" => "profile/collaborators", "right_panel" => "profile/right"}
  user = params[:username]  
  @menu_data = profile_home_info(user)
  set_profile_page_info user
  erb(:"body/structure")
end

get '/:username/actions' do
  erb(:"profile/actions", :locals => {:user => get_passed_user})
end

get '/:username/unfollow' do
  begin
    Follower.remove(session_user?, get_passed_user)
    "You are not following #{get_passed_user.name} anymore"
  rescue Exception => e
    status 500
    e.message
  end
end

get '/:username/profile_picture' do
  send_file("/home/jammmin/storage/me.png")
#  send_file(User.with_username(param?(:username)).profile_picture,{
#    :filename => "profile_picutre",
#    :disposistion => "inline"
#  })
end

get '/:username/jammed_with' do
  @user = User.with_username(params[:username])
  @layout_info = {"left_panel" => "profile/menu", "middle_panel" => "profile/jammed_with"}
  @menu_data = profile_home_info(@user.username)
  erb(:'body/structure')
end

get '/:username/info' do
  @layout_info = {
    'left_panel' => 'profile/menu',
    "middle_panel" => 'profile/info'
  }
  @menu_data = profile_home_info(params[:username])
  erb(:"body/structure")
end
