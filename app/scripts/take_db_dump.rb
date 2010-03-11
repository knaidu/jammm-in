require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

cron_log_new_section("TAKING AT DATABASE DUMP")
Daemons.daemonize # Runs the script in the background

Dump.take_dump
