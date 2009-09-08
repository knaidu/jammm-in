require 'rubygems'
require 'sinatra'
require 'yaml'

# Loads all the file under folder lib
`ls lib`.split("\n").each do |file| load("lib/#{file}") end

set :public, File.dirname(__FILE__) + '/public'

include Utils

helpers do
  load('helpers/all.rb')
end

get '/' do
  "Welcome to jamMm.in"
end

get '/get_layout' do
  get_layout('account').inspect
end

# Loads all the account urls e.g: account/home
load 'urls/account.rb'
