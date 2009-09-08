require 'rubygems'
require 'sinatra'

set :public, File.dirname(__FILE__) + '/public'

get '/start' do
  "Welcome to jamMm.in"
end

get '/account' do
  "Account"
end
