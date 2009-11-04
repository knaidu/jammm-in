
def partial(page, options={})
  page = page.to_s
  puts "page is: " + page
  return "&nbsp;" if page.empty? or not page or page.nil? or page.split("/").include?('nil')
  erb(:"#{page}", options.update({:layout => false}))
end

def redirect_home
  redirect '/account'
end

def redirect_signin
  redirect '/signin'
end

def redirect_manage_jam(jam)
  redirect "/jam/#{jam.id}/manage"
end

def show_profile(username)
  redirect "/#{username}"
end

def section_header(text, options={})
  [
    "<div>",
      "<span class='float-left bold'>#{text.capitalize}</span>",
    "</div>",
    "<hr class='thin'>"
  ].join('')
end

def add_feed_item(text)
end

def add_menu_entry(text, link, image_url)
	"<div>
		<a title='#{text}' href='#{link}' class='bold grey display-inline'>
		  <div>
  		  <span class='float-left'>#{text}</span>
	  	  <span class='float-right'>#{add_icon()}</span>
	  	</div>
		</a>
	</div>"
end


def add_link(text, href='', options={})
  class_names = "simple-link " + (options[:class_names] or "")
  "<span class='#{class_names} display-inline'><a href='#{href}'>#{text}</a></span>"
end

def add_icon(icon=false)
  "<img src='/images/common/icon.png'>"
end

def add_field_name(text)
  "<span class='display-inline bold grey'>" + text + ":</span>"
end

def add_profile_link(user)
  add_link(user.name, ("/" + user.username)) rescue ""
end

def list_artists(artists)
  partial(:'common/list_artists', {:locals => {:artists => artists}})
end

def manage_if_not_signed_in
  redirect_signin if not session[:username]
end

load 'helpers/profile.rb'
