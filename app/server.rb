require 'rubygems'
require 'sinatra'
require 'yaml'

set :public, File.dirname(__FILE__) + '/public'

load 'db/db_connect.rb'
load 'scripts/load_libs.rb'
load 'scripts/load_models.rb'

helpers do
  load('helpers/all.rb')
end

get '/' do
  "Welcome to jamMm.in"
end


# Url Catcher for .css files. If not found, it will look for a static file.
get '/stylesheets/*.css' do
  filename = params[:splat][0]
  erb :"stylesheets/#{filename}"
end

load 'urls/signup.rb'

# Loads all the account urls e.g: /account/home
load 'urls/account.rb'

# Loads all the profile urls eg: /user1, /user2
load 'urls/profile.rb'

# Loads all the songs urls eg: /song/song_id
load 'urls/song.rb'
