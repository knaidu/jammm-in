
def partial(page)
  return "&nbsp;" if page.to_s.empty? or not page
  erb(:"#{page}", :layout => false)
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
  "<span class='#{class_names}'>
    <a href='#{href}'>#{text}</a>
  </span>"
end

load 'helpers/profile.rb'
