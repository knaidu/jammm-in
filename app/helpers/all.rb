# JS

def js_start; "<script language='javascript'>"; end
def js_end; "</script>"; end

# END JS 

def partial(page, options={})
  page = page.to_s
  return "&nbsp;" if page.empty? or not page or page.nil? or page.split("/").include?('nil')
  layout = (options[:container_id] or options[:section_header]) ? :"common/partial_layout"  : false
  erb(:"#{page}", options.update({:layout => layout}))
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

def redirect_manage_song(song)
  redirect "/song/#{song.id}/manage"
end

def show_profile(username)
  redirect "/#{username}"
end

def section_header(text, options={})
  img = icon(options[:icon], :small) if options[:icon]
  partial("common/section_header", :locals => {
    :img => img,
    :text => text,
    :options => options
  })
end

def add_menu_entry(text, link, image)
  img = image.sym? ? icon(image, :small) : add_icon(image)
  puts image.sym?
	"<div>
		<a title='#{text}' href='#{link}' class='bold grey display-inline'>
		  <div>
	  	  <span class='float-left pad-right-10'>#{img}</span>
  		  <span class='display-inline'>#{text}</span>
	  	</div>
		</a>
	</div>"
end


def add_link(text, href='', options={})
  class_names = "simple-link " + (options[:class_names] or "")
  "<span class='#{class_names} display-inline'><a href='#{href}'>#{text}</a></span>"
end

def link(text, options={})
  options[:class] = "simple-link display-inline " + (options[:class] || "")
  attrs = options.map{|k,v| "#{k.to_s}='#{v}'"}.join(' ')
  "<span #{attrs}>" + text + "</span>"
end

def add_field_name(text)
  "<span class='display-inline bold grey'>" + text + ":</span>"
end

def add_profile_link(user)
  add_link(user.name, ("/" + user.username)) rescue ""
end
alias profile_link add_profile_link

def jam_link(jam)
  add_link(jam.name, ("/jam/" + jam.id.to_s))
end

def song_link(song)
  add_link(song.name, ("/song/" + song.id.to_s))
end

def list_artists(artists)
  partial(:'common/list_artists', {:locals => {:artists => artists}})
end

def manage_if_not_signed_in
  redirect_signin if not session[:username]
end

def display_published
  "<span class='bold display-inline' style='color: green'>PUBLISHED</span>"
end

def display_unpublished
  "<span class='bold display-inline' style='color: red'>UNPUBLISHED</span>"  
end

def display_jam_type(jam)
  return "Song Jam" if jam.jam_type == :song_jam
  jam.jam_type == :published ? "Published" : "Unpublished"
end

def session_user? 
  @session_user if @session_user
end

def load_player(player_type=nil)
  partial("common/player", {:locals => {:player_type => player_type}})
end

def format_lyrics(lyrics)
  return "" if not lyrics
  lyrics.gsub("\n", "<br>")
end

def manage_song_link(song)
  "<span class='pad1'><a href='/song/#{song.id}/manage' title='Manage'>#{icon :manage}</a></span>"
end

def manage_jam_link(jam)
  "<span class='pad1'><a href='/jam/#{jam.id}/manage' title='Manage'>#{icon :manage}</a></song>"  
end

def monitor
  yield if block_given?
rescue Exception => e
  render_error(e)
end

def render_error(exception)
  status 500
  puts exception.message
  exception.message
  rescue Exception => ex
    ex.message
end

def add_music_link(obj)
  prm = obj.class.to_s.downcase + "_" + obj.id.to_s
  puts obj.id
  "<a href='/song/add_music?add=#{prm}'><span class='display-inline' title='Add to garage'>" + (icon :add) + "</span></a>" 
end

def play_link(obj)
  "<span onclick=play('','') class='simple-link display-inline'>#{icon :play2}</span>"
end

def vspace(height=5)
  "<div style='height: #{height}'></div>"
end

def field(text, options={})
  width = options[:width] || false
  "<div class='field align-top'>#{text}</div>"
end

def param?(key)
  params[key.to_sym]
end

def get_params?(*keys)
  keys.map do |key| param?(key.to_sym) end
end

def rand_id
  "id-" + rand.to_s
end

def list_genres(genres)
  genres.map(&:name).join(", ")
end

load 'helpers/profile.rb'
