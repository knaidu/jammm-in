require 'rubygems'
require 'sinatra'
require 'ftools'
require 'yaml'
require 'aws/s3'
require 'digest/md5'


set :public, File.dirname(__FILE__) + '/public'
enable :sessions

load 'db/db_connect.rb'
load 'scripts/s3_connect.rb'
load 'scripts/load_libs.rb'
load 'scripts/load_models.rb'

helpers do
  load('helpers/all.rb')
  load('helpers/feed.rb')
  load('helpers/icons.rb')
  load('helpers/classes.rb')
end

before do
  @session_user ||= (User.with_username(session[:username]) rescue nil)
end

get '/' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "homepage/middle", "right_panel" => "homepage/right"}
  erb(:'body/structure')
end


# Url Catcher for .css files. If not found, it will look for a static file.
get '/stylesheets/*.css' do
  filename = params[:splat][0]
  erb :"stylesheets/#{filename}"
end

get '/test' do
  {:done => true, :failed => false}.to_json
end

get '/aboutus' do
  @layout_info = {"left_panel" => "", "middle_panel" => "help/aboutus"}
  erb(:'body/structure')
end

get '/partial/*' do
#  path, locals = parse_url(params["splat"])
  path = params["splat"]
  erb(:"#{path}", :locals => params.clone)
end

get '/admin/site_counter' do
  @layout_info = {"left_panel" => "homepage/left", "middle_panel" => "admin/site_counter"}
  erb(:'body/structure')
end

load 'urls/signin.rb'
load 'urls/signup.rb'

# Loads all the account urls e.g: /account/home
load 'urls/account.rb'

# Loads all the message_stream urls
load 'urls/message_stream.rb'

# Loads all the profile urls eg: /user1, /user2
load 'urls/profile.rb'

# Loads all the songs urls eg: /song/song_id
load 'urls/song.rb'

# Loads all the Jams urls eg: /jam/jam_id
load 'urls/jam.rb'

# Loads all the Jams urls eg: /jam/jam_id
load 'urls/comment.rb'

# Loads all the files urls eg: /files/:file_handle
load 'urls/file.rb'

# Loads all the process_info urls
load 'urls/process_info.rb'

# Loads all the genres urls
load 'urls/genre.rb'

# Loads all the instruments urls
load 'urls/instrument.rb'

# Loads all the tag urls
load 'urls/tag.rb'
