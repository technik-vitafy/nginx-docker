#!/bin/sh
set -e

cp -R /app/etc/* /etc

chmod +x /etc/service/*/run

ln -s /app/bin/add_user.sh /etc/my_init.d/00_add_user.sh
