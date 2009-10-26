
def add_profile_menu_item(text, link, icon=false)
  [
    "<div>",
    text,
    "</div>"
  ].join('')
end


def add_profile_menu_user_info_item(field, value)
  [
    "<div>",
      "<span class='bold grey left-float pad-right-5'>#{field}:</span>",
      value,
    "</div>"
  ].join('')
end


def add_user_action(config={})
  [
    "<div>",
      "<span class='float-left'>" + add_icon + "</span>",
      "<span class='pad-left-5 simple-link'>" + config[:text] + "</span>",
    "</div>"
  ].join('')
end


def show_dummy_data(user_id)
  songs = get_dummy_names(user_id)
  songs
end

def format_dummy_data(user_id)
  show_dummy_data(user_id).map { |data|
    "<b>" + data + "</b><br>"
  }.join('')
end


def set_profile_page_info(username)
  @user = User.with_username(username)
end
