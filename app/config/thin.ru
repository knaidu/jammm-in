## This is not needed for Thin > 1.0.0
env_vars = {
	'RACK_ENV' => "production",
	'FILES_DIR' => "/home/jammmin/files",
  'CACHE_DIR' => "/home/jammmin/cache",
  'WEBSERVER_ROOT' => "/home/jammmin/webserver/app",
  'STORAGE_DIR' => "/home/jammmin/storage"
}

#ENV.update(env_vars)

log = File.new("/home/jammmin/log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require "/home/jammmin/webserver/app/server.rb"

run Sinatra::Application
