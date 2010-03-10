env_vars = {
	'RACK_ENV' => "production",
	'FILES_DIR' => "/home/jammmin/files",
  'CACHE_DIR' => "/home/jammmin/cache",
  'WEBSERVER_ROOT' => "/home/jammmin/webserver/app",
  'STORAGE_DIR' => "/home/jammmin/storage"
}

ENV.update(env_vars)
