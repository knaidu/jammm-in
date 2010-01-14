require 'ftools'

root = ENV["WEBSERVER_ROOT"]
load "#{root}/scripts/load_requires.rb"
load "#{root}/db/db_connect.rb"
load "#{root}/scripts/s3_connect.rb"
load "#{root}/scripts/load_libs.rb"
load "#{root}/scripts/load_models.rb"
