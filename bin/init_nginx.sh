#!/bin/sh
set -e

# Forward the request end error log to the docker log collector
ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy the default config to the nginx folder
cp /app/nginx/nginx.conf /etc/nginx/nginx.conf
