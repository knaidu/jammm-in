require 'logger'
require "/home/jammmin/webserver/app/server.rb"

log_path = "/home/jammmin/log/sinatra.log"
LOGGER = Logger.new(log_path, "daily")
log = File.new(log_path, "a+")
STDOUT.reopen(log)
STDERR.reopen(log)
  

run Sinatra::Application
