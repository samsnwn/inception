#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(grep "^WP_ADMIN_PASSWORD=" /run/secrets/credentials | cut -d '=' -f2-)
WP_PASSWORD=$(grep "^WP_PASSWORD=" /run/secrets/credentials | cut -d '=' -f2-)

mkdir -p /var/www/inception/
chown -R www-data:www-data /var/www/inception/

sleep 10

wp --allow-root --path="/var/www/inception/" core download || true

if [ ! -f "/var/www/inception/wp-config.php" ]; then
    wp --allow-root --path="/var/www/inception/" config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST"
fi

if ! wp --allow-root --path="/var/www/inception/" core is-installed >/dev/null 2>&1; then
    wp --allow-root --path="/var/www/inception/" core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"
fi

if ! wp --allow-root --path="/var/www/inception/" user get "$WP_USER" >/dev/null 2>&1; then
    wp --allow-root --path="/var/www/inception/" user create \
        "$WP_USER" \
        "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role="$WP_ROLE"
fi

wp --allow-root --path="/var/www/inception/" theme install raft --activate || true

chown -R www-data:www-data /var/www/inception/

exec "$@"