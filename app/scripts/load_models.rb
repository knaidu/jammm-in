require 'rubygems'
require 'activerecord'
require 'pg'

app_root = ENV['WEBSERVER_ROOT']
models = `ls #{app_root}/models`.split("\n")
puts 'models are: ' + models.inspect
models.each do |model| require "#{app_root}/models/#{model}" end