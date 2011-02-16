
# Loads the user profile page 
get '/:username' do
  user = params[:username]
  is_user = User.find_by_username(user)
  @user = is_user
  erb(:"profile/page")
end


get '/:username/context_menu' do
  @user = User.with_username param?(:username)
  erb(:"/profile/context_menu")
end


get '/:username/feeds' do
  @user = User.with_username param?(:username)
  @feeds = @user.updates
  erb(:"/profile/feeds")
end


get '/:username/songs' do
  @user = get_passed_user
  @songs = @user.published_songs
  erb(:"/profile/songs")
end


get '/:username/jams' do
  @user = get_passed_user
  @jams = @user.displayable_jams
  erb(:"/profile/jams")
end

get '/:username/followers' do
  @user = User.with_username param?(:username)
  erb(:"/profile/followers")
end

get '/:username/following' do
  @user = User.with_username param?(:username)
  erb(:"/profile/following")
end

post '/:username/follow' do
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

post '/:username/unfollow' do
  begin
    Follower.remove(session_user?, get_passed_user)
    "You are not following #{get_passed_user.name} anymore"
  rescue Exception => e
    status 500
    e.message
  end
end

get '/:username/profile_picture' do
  send_file(User.with_username(param?(:username)).profile_picture,{
    :filename => "profile_picutre",
    :disposistion => "inline"
  })
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

get '/:username/send_message' do
  @user = get_passed_user
  erb(:"/profile/send_message")
end