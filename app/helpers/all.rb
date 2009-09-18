
def partial(page)
  return "" if page.to_s.empty? or not page
  erb(:"#{page}", :layout => false)
end

def redirect_home
  redirect '/account'
end

def show_profile(username)
  redirect "/#{username}"
end

def section_header(text)
  "<b>#{text.capitalize}</b><hr class='thin'>"
end

def testhelper

end
