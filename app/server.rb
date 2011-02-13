require 'rubygems'
require 'sinatra'
require 'ftools'
require 'yaml'
require 'aws/s3'
require 'digest/md5'
require 'pony'
require 'net/http'

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
  @use_full_paths = param?(:use_full_paths) or false
  headers ("Content-Type" => "text/html; charset=utf-8")
end

get '/' do
  erb(:'body/structure')
end

get '/test1' do
  erb(:"test/1")
end

get '/test2' do
  erb(:"test/2")  
end

get '/test3' do
  "Data is here"
end


get '/env' do
  ENV.inspect
end

# Url Catcher for .css files. If not found, it will look for a static file.
get '/stylesheets/*.css' do
  filename = params[:splat][0]
  content_type "text/css"
  erb :"stylesheets/#{filename}"
end

get '/test' do
  {:done => true, :failed => false}.to_json
end

get '/aboutus' do
  erb(:"/help/aboutus")
end

get '/partial/*' do
#  path, locals = parse_url(params["splat"])
  path = params["splat"]
  erb(:"#{path}", :locals => params.clone)
end

load 'urls/signin.rb'
load 'urls/signup.rb'
load 'urls/schools.rb'
load 'urls/badge.rb'
load 'urls/chat.rb'
load 'urls/help.rb'
load 'urls/admin.rb'
load 'urls/videos.rb'
load 'urls/search.rb'
load 'urls/homepage.rb'
load 'urls/bug.rb'
load 'urls/account.rb'
load 'urls/message_stream.rb'
load 'urls/song.rb'
load 'urls/jam.rb'
load 'urls/comment.rb'
load 'urls/file.rb'
load 'urls/sessions.rb'
load 'urls/process_info.rb'
load 'urls/genre.rb'
load 'urls/instrument.rb'
load 'urls/tag.rb'
load 'urls/groups.rb'
load 'urls/profile.rb'