get '/schools/:handle' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/middle', "left_panel" => "schools/left", "right_panel" => "schools/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/jams' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/jams', "left_panel" => "schools/left", "right_panel" => "schools/right"}
    erb(:"body/structure") 
  }
end

get '/schools/:handle/songs' do
  school_exists?{
    @school = get_passed_school  
    @layout_info = {"middle_panel" => 'schools/songs', "left_panel" => "schools/left", "right_panel" => "schools/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/members' do
  school_exists?{
    @school = get_passed_school  
    @layout_info = {"middle_panel" => 'schools/members', "left_panel" => "schools/left"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/admin' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/admin/middle', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/admin/add' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/admin/add', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

post '/schools/:handle/admin/add_user' do
  monitor{
    @school = get_passed_school
    raise "School not found. Please check the school been passed" if @school.nil?
    user = User.with_username(param?(:username))
    raise "User with username '#{param?(:username)}' is not found. Please check the username" if user == nil
    @school.add_user(user)
    "The user has been successfully added to the school"
  }
end

get '/schools/:handle/admin/delete' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/admin/delete', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/admin/manage' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/admin/manage', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/admin/list' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/admin/list', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

post '/schools/:handle/admin/add_update' do # you had mentioned this api with the "get" method, but your form was using a "post" method. all operations must be post
  monitor {
    username = params[:name] # variable name does not follow camel casing, hence it should be username or user_name.
    school = School.with_handle(params[:handle])
    raise "The specifed school does not exists" unless school
    user =  User.with_username(username)
    raise "The specifed artist does not exist." unless user # "unless" is equivalent to "if not"
    ret = school.add_user(user)
    "Successfully Added user to the School"
  } # Look at what "monitor" does. in helpers/all.rb
end


post '/schools/:handle/admin/delete_user' do # you had mentioned this api with the "get" method, but your form was using a "post" method. all operations must be post
  monitor {
    username = params[:name] # variable name does not follow camel casing, hence it should be username or user_name.
    school = School.with_handle(params[:handle])
    raise "The specifed school does not exists" unless school
    user =  User.with_username(username)
    raise "The specifed artist does not exist." unless user # "unless" is equivalent to "if not"
    ret = school.add_user(user)
    "Successfully Added user to the School"
  } # Look at what "monitor" does. in helpers/all.rb
end

