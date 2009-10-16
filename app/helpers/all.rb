
def partial(page, options={})
  page = page.to_s
  puts "page is: " + page
  return "&nbsp;" if page.empty? or not page or page.nil? or page.split("/").include?('nil')
  erb(:"#{page}", options.update({:layout => false}))
end

def redirect_home
  redirect '/account/home'
end

def show_profile(username)
  redirect "/#{username}"
end

def section_header(text)
  "<b>#{text.capitalize}</b><hr class='thin'>"
end

def add_feed_item(text)
end

def add_menu_entry(text, link, image_url)
	"<div>
		<a  title='#{text}' href='#{link}'>
			<div >
				<img src='#{image_url}' />
				<div> #{text} <hr></div>
			</div>
		</a>
	</div>"
end


def add_link(text, href, options={})
  class_names = (options[:class_names] or "") + " simple-link"
  "<span class='#{class_names} display-inline'><a href='#{href}'>#{text}</a></span>"
end

def add_icon(icon=false)
  "<img src='/images/common/icon.png'>"
end

def add_field_name(text)
  "<span class='display-inline bold grey'>" + text + "</span>:"
end

def add_profile_link(user)
  add_link(user.name, ("/" + user.username))
end

def list_artists(artists)
  partial(:'common/list_artists', {:locals => {:artists => artists}})
end

load 'helpers/profile.rb'
