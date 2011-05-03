module UserUtils

  def create_new_user(user_info)
    validate_username(user_info[:username])
    code = user_info[:code]
    is_group_promotion_code = code.split(";")[1] == "group" ? true : false
    is_promotion_code = code.split(";")[1] == "code" ? true : false
    if is_group_promotion_code
      group = Group.group_from_code(code)
      raise "No more accounts may be creating using this promotion code. Please contact your groups administrator" if group.invites_remaining < 1
    elsif is_promotion_code
      pc = PromotionCode.pc_from_code_str(code)
      raise "Please check the promotion code." unless pc
      raise "No more accounts may be created using this promotion code." if pc.invites_remaining < 1
    else
      invite = Invite.extract_invite(user_info[:code])
    end
    
    user_info[:password] = md5(user_info[:password])
    email = user_info[:email]
    raise "Please enter a valid email address" if email.empty?
    raise "An account with this email address has already been created." if User.find_by_email(email)
    user = User.create!({
      :name => user_info[:name],
      :username => user_info[:username],
      :password => user_info[:password],
      :email => email,
      :location => user_info[:location]
    })
    invite.mark_as_used if user and (not is_promotion_code)
    user.send_acknowledgement
    if is_group_promotion_code
      group.add_user(user) 
      group.decrement_invites_remaining
    elsif is_promotion_code
      pc.decrement_invites_remaining
      pc.register_user(user)
    end
    user
  end
  
  def validate_username(username)
    regex = INVALID_INFO["username"]["regex"]
    raise "The username can accept only alphabets,numbers, '-' and '_'" if not eval(regex).match(username)
    raise "Username '#{username}' is a reserved keyword. Please choose another one." if INVALID_INFO['username']['names'].include?(username)
  end
  
  def profile_home_info(username)
    user = User.find_by_username(username)
    data = {:personal_info => user.personal_info}
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
