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

def render_state(state)
  partial("common/state", :locals => {:state => state})
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

def panel_header(text, icon=false)
  partial ("common/panel_header", :locals => {:text => text, :icon => icon})
end

def add_menu_entry(text, link, image)
  img = image.sym? ? icon(image, :small) : add_icon(image)
	"<div class='account-menu-item'>
		<a title='#{text}' href='#{link}'>
		  <div>
	  	  <span class='float-left pad-right-10'>#{img}</span>
  		  <span class='item-text'>#{text}</span>
	  	</div>
		</a>
	</div>"
end

def load_menu_items(items=[])
  partial("common/menu", :locals => {:items => items})
end


def add_link(text, href='', options={})
  class_names = "simple-link " + (options[:class_names] or "")
  "<span class='#{class_names} display-inline'><a href='#{href}' class='#{class_names}'>#{text}</a></span>"
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
  add_link(user.username, ("/" + user.username), {:class_names => "profile-link"})
end
alias profile_link add_profile_link

def jam_link(jam)
  add_link(jam.name, ("/jam/" + jam.id.to_s))
end

def song_link(song)
  add_link(song.name, ("/song/" + song.id.to_s))
end

def song_picture(song)
  partial("common/song_picture", :locals => {:song => song})
end

def play_link(obj=nil, file_path=nil, title=nil)
  partial ("common/play", :locals => {:obj => obj, :file_path => file_path, :title => title})
end

alias play play_link

def download(obj)
  partial ("common/download", :locals => {:obj => obj})
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
  "<span class='pad1 display-inline-block'><a href='/song/#{song.id}/manage' title='Edit Song'>#{icon :manage}</a></span>"
end

def manage_jam_link(jam)
  "<span class='display-inline-block pad1'><a href='/jam/#{jam.id}/manage' title='Edit Jam'>#{icon :manage}</a></song>"  
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

def allowed?(users)
  if (not users.include?(session_user?))
    @layout_info = {'middle_panel' => 'common/not_allowed', 'left_panel' => 'homepage/left'}
    erb(:"body/structure")
  else
    yield if block_given?
  end
end 

def logged_in?
  if (not session_user?)
    @layout_info = {'middle_panel' => 'common/not_allowed', 'left_panel' => 'homepage/left'}
    erb(:"body/structure")
  else
    yield if block_given?
  end
end


def add_music_link(obj)
  prm = obj.class.to_s.downcase + "_" + obj.id.to_s
  "<a href='/song/add_music?add=#{prm}' style='text-decoration: none !important'><span class='display-inline' title='Add to garage'>" + (icon :add) + "</span></a>" 
end

def add_music_link_text(obj, text)
  prm = obj.class.to_s.downcase + "_" + obj.id.to_s
  "<a href='/song/add_music?add=#{prm}' style='text-decoration: none !important'><span class='display-inline' title='Add to garage'>" + text + "</span></a>"
end

def play_link(obj)
  "<span onclick=play('','') class='simple-link display-inline'>#{icon :play2}</span>"
end


def vspace(height=5)
  "<div style='height: #{height}px; overflow: hidden'>&nbsp;</div>"
end

def hor_line(px='1px', style='solid', color='black', margin='0px')
  "<div style='border-top: #{px} #{style} #{color}; margin: #{margin}'> </div>"
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

def list_instruments(instruments)
  instruments.map(&:name).join(", ")
end

def list_tags(tags)
  tags.map(&:name).join(", ")
end

# MAIN-INFO
def main_info_row(field, value)
  partial("common/main_info/row", :locals => {:field => field, :value => value})
end

def main_info_hor_line
  hor_line("1px", "dotted", "#999999", "5px 0px 5px 0px")
end

# SHARE

def twitter_share(obj)
  partial("common/twitter_share", :locals => {:obj => obj})
end

def facebook_share(obj)
  partial("common/facebook_share", :locals => {:obj => obj})
end

# Blankets
def blanket_events
  "onmouseover='onMouseOverBlanket(this)' onmouseout='onMouseOutBlanket(this)'"
end

def bug_statuses
  DATA["bug_statuses"]
end

# EMAIL_STYLES

def email_styles
  {
    :layout => "width:550px; font:12px arial, sans-serif;margin:0;",
    :main_heading => "color: #990000 !important; font-size: 14px;",
    :section_heading => "color: #666; margin-bottom: 10px;",
    :section_content => "margin-left: 20px;"
  }
end

# SAY FORMATTER
def format_say(message)
  str = message.gsub(eval(DATA["say_mention_username_regex"])) {|username|
    user = User.with_username(username.gsub("@", ""))
    user ? "<a class='default-color' href='/#{user.username}'>#{username}</a>" : username
  }
  str.gsub_href
end

# School Helpers
def school_exists?
  school = School.with_handle(param?(:handle))
  unless school
    @layout_info = {'middle_panel' => 'schools/not_found'}
    erb(:"body/structure")
  else
    yield if block_given?
  end
end


load 'helpers/profile.rb'
