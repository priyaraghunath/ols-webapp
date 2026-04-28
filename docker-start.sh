#!/bin/bash
set -e

echo "==> Injecting DB credentials into wp-config.php"

sed -i "s|database_name_here|${WORDPRESS_DB_NAME}|g" /var/www/vhosts/localhost/html/wp-config.php
sed -i "s|username_here|${WORDPRESS_DB_USER}|g" /var/www/vhosts/localhost/html/wp-config.php
sed -i "s|password_here|${WORDPRESS_DB_PASSWORD}|g" /var/www/vhosts/localhost/html/wp-config.php
sed -i "s|localhost|${WORDPRESS_DB_HOST}|g" /var/www/vhosts/localhost/html/wp-config.php

echo "==> wp-config.php updated:"
grep -E "DB_NAME|DB_USER|DB_PASSWORD|DB_HOST" /var/www/vhosts/localhost/html/wp-config.php

echo "==> Starting OpenLiteSpeed"
exec /entrypoint.sh