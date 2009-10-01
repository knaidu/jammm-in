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
    data = {
      :personal_info => user.personal_info
    }
  end
  
end
