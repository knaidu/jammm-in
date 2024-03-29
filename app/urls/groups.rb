get '/schools/:school_handle' do
  redirect "/groups/#{param?(:school_handle)}"
end

get '/groups/home' do
  erb(:"/groups/home")
end

get '/groups/:handle' do
  @group = Group.with_handle param?(:handle)
  erb(:"/groups/page")
end

get '/groups/:handle/feeds' do
  @group = Group.with_handle param?(:handle)
  @feeds = @group.feeds 30
  erb(:"/groups/feeds")
end

get '/groups/:handle/jams' do
  @group = Group.with_handle param?(:handle)
  @jams = @group.jams
  erb(:"/groups/jams")
end

get '/groups/:handle/songs' do
  @group = Group.with_handle param?(:handle)
  @songs = @group.songs
  erb(:"/groups/songs")
end

get '/groups/:handle/members' do
  @group = Group.with_handle param?(:handle)
  @users = @group.users
  erb(:"/groups/members")
end

get '/groups/:handle/context_menu' do
  @group = Group.with_handle param?(:handle)
  erb(:"/groups/context_menu")
end

get '/groups/:handle/manage' do
  @group = get_passed_group
  allowed?(@group.admins){
    erb(:"/groups/manage/page")
  }
end

post '/groups/:handle/manage/update_info' do
  @group = get_passed_group
  allowed?(@group.admins){
    group = Group.with_handle(param?(:handle)).update_info(param?(:key), param?(:value))
  }
end

get '/groups/:handle/manage/update_picture' do
  @group = get_passed_group
  allowed?(@group.admins){
    erb(:"/groups/manage/update_picture")
  }
end

get '/groups/:handle/manage/update_picture/form' do
  @group = get_passed_group
  allowed?(@group.admins){
    erb(:"/groups/manage/update_picture_form")
  }
end

post '/groups/:handle/manage/update_picture/submit' do
  @group = get_passed_group
  allowed?(@group.admins){
    file = param?(:picture)[:tempfile]
    puts file
    @group.change_profile_picture(file)
    file.unlink
    erb(:"/groups/manage/picture_updated")
  }
end

post '/groups/:handle/manage/remove_user' do
  @group = get_passed_group
  allowed?(@group.admins){
    monitor {
      group = Group.with_handle param?(:handle)
      user = User.find(param?(:user_id))
      group.remove_user(user)
      "Successfully removed user"
    }
  }
end

get '/groups/:handle/profile_picture' do
  send_file(Group.with_handle(param?(:handle)).profile_picture, {
    :filename => "group_picutre",
    :disposistion => "inline"
  })
end