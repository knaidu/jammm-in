
def show_dummy_data(user_id)
  songs = get_dummy_names(user_id)
  songs
end

def format_dummy_data(user_id)
  show_dummy_data(user_id).map { |data|
    "<b>" + data + "</b><br>"
  }.join('')
end

def profile_link(user)
  " onclick='Navigate.loadContent(\"/#{user.username}\")' "
end