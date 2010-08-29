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


get '/school/:handle/user/delete' do
  school = get_passed_school
  uid = params[:userid]
  user = User.find(uid)
  school.find(id).remove_user(user) ? "Deleted User"  : "Error in deleting user"
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
    name, address, phone_number = get_params(:name, :address, :phone_number) # Look up what get_params is
    school = get_passed_school
    raise "The specifed school does not exists" unless school
    ret = school.update_info({:name => name, :address => address, :phone_number => phone_number}) # Look up update_info in models/school.rb
    "School information has been successfully updated"
  }
end

post '/schools/:handle/admin/invite_email' do
  monitor {
    email = param?(:email)
    raise "There is already a user with the email address #{email} registered with jammm.in" if User.find_by_email(email)
    school = get_passed_school
    school.invite(email)
    "An invte has been sent to the email #{email}"
  }
end