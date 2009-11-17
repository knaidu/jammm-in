require 'rubygems'
require 'sinatra'
require 'ftools'
require 'yaml'

set :public, File.dirname(__FILE__) + '/public'
enable :sessions

load 'db/db_connect.rb'
load 'scripts/load_libs.rb'
load 'scripts/load_models.rb'

helpers do
  load('helpers/all.rb')
end

before do
  @session_user ||= User.with_username(session[:username])
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

load 'urls/signin.rb'
load 'urls/signup.rb'

# Loads all the account urls e.g: /account/home
load 'urls/account.rb'

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
