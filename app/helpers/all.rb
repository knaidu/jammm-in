
def partial(page)
  erb(:"#{page}", :layout => false)
end

def redirect_home
  redirect '/account'
end
