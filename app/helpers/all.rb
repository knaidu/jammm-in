
def partial(page)
  erb(:"#{page}", :layout => false)
end

def redirect_home
  redirect '/account'
end

def section_header(text)
  "<b>#{text.capitalize}</b><hr class='thin'>"
end