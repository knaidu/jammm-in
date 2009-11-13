## This is not needed for Thin > 1.0.0
ENV['RACK_ENV'] = "production"

require "#{ENV["WEBSERVER_ROOT"]}/server.rb"

run Sinatra::Application
