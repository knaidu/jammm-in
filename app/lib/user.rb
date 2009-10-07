module UserUtils

  def create_new_user(user_info)
    User.create(user_info)
  end
  
  def profile_home_info(username)
    user = User.find_by_username(username)
    data = {
      :personal_info => user.personal_info
    }
  end
  
  def user_data(username, section)
    user = User.find_by_username(username)
    section_data = eval("user_#{section}('#{username}')")
    {:personal_info => user.personal_info}.update(section_data)
  end
  
  def user_info(username)
    {:personal_info => User.find_by_username(username).personal_info}
  end
  
  # Returns data for the information page e.g: user/info
  def user_info(username) 
    user = User.with_username(username)
    user.personal_info
  end
  
end
