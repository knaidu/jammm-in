module UserUtils

  def create_new_user(user_info)
    User.create(user_info)
  end
  
end
