#!/bin/bash

echo "Starting entrypoint script..."

# Substitute real values from ECS env vars into wp-config.php at startup
sed -i "s|database_name_here|${WORDPRESS_DB_NAME}|g" /var/www/vhosts/localhost/html/wp-config.php
sed -i "s|username_here|${WORDPRESS_DB_USER}|g" /var/www/vhosts/localhost/html/wp-config.php
sed -i "s|password_here|${WORDPRESS_DB_PASSWORD}|g" /var/www/vhosts/localhost/html/wp-config.php
sed -i "s|localhost|${WORDPRESS_DB_HOST}|g" /var/www/vhosts/localhost/html/wp-config.php

echo "wp-config.php updated with database credentials"

# Hand off to the original OpenLiteSpeed entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"