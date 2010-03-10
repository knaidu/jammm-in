#!/bin/bash

echo 'Stopping Web Server...'
sudo killall nginx
echo "Starting Web Server..."
sudo -E /opt/nginx/sbin/nginx -c /home/jammmin/webserver/app/config/nginx.conf 

