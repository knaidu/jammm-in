require 'rubygems'
require 'sinatra'

set :public, File.dirname(__FILE__) + '/public'

helpers do
  load('helpers/all.rb')
end

get '/' do
  "Welcome to jamMm.in"
end

# Loads all the account urls e.g: account/home
load 'urls/account.rb'
