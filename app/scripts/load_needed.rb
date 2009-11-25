require 'ftools'

root = ENV["WEBSERVER_ROOT"]
load "#{root}/db/db_connect.rb"
load "#{root}/scripts/load_libs.rb"
load "#{root}/scripts/load_models.rb"
