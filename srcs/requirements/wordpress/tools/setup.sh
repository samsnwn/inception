#!/bin/bash

set -e

mkdir -p /var/www/inception/
chown -R www-data:www-data /var/www/inception/

if [ ! -f "/var/www/inception/wp-config.php" ]; then
   mv /tmp/wp-config.php /var/www/inception/
fi

sleep 10

echo "WP_USER=$WP_USER"
echo "WP_EMAIL=$WP_EMAIL"

wp --allow-root --path="/var/www/inception/" core download || true

if ! wp --allow-root --path="/var/www/inception/" core is-installed; then
    wp --allow-root --path="/var/www/inception/" core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
fi

if ! wp --allow-root --path="/var/www/inception/" user get "$WP_USER" >/dev/null 2>&1; then
    wp --allow-root --path="/var/www/inception/" user create \
        "$WP_USER" \
        "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role="$WP_ROLE"
fi

wp --allow-root --path="/var/www/inception/" theme install raft --activate || true

exec "$@"