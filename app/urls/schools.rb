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
    @layout_info = {"middle_panel" => 'schools/admin/manage_users', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/admin/manage_users' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/admin/manage_users', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

get '/schools/:handle/admin/manage_school' do
  school_exists?{
    @school = get_passed_school
    @layout_info = {"middle_panel" => 'schools/admin/manage_school', "left_panel" => "schools/admin/left", "right_panel" => "schools/admin/right"}
    erb(:"body/structure")
  }
end

post '/schools/:handle/admin/add_user_api' do
  monitor {
    username = params[:name]
    school = get_passed_school
    raise "The specifed school does not exists" unless school
    user =  User.with_username(username)
    raise "The specifed artist does not exist." if user.nil?
    ret = school.add_user(user)
    "Successfully Added user to the School"
  } 
end


post '/schools/:handle/admin/manage_school_api' do 
  monitor {
    school_name = params[:school_name]
    school_address = params[:school_address]
    school_phone = params[:school_phone]
    school = get_passed_school
    raise "The specifed school does not exists" unless school
    ret = school.add_user(user)
    "Successfully Added user to the School"
  } # Look at what "monitor" does. in helpers/all.rb
end

