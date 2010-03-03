#!/bin/bash

echo 'Stopping Web Server...'
sudo killall nginx
echo "Starting Web Server..."
sudo /opt/nginx/sbin/nginx -c /home/jammmin/webserver/app/config/nginx.conf 

