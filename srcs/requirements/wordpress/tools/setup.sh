#!/bin/bash

set -e

WP_PATH="/var/www/inception"
DB_HOST="${DB_HOST:-mariadb}"

mkdir -p "$WP_PATH"
chown -R www-data:www-data "$WP_PATH"

wp_cli() {
    php -d memory_limit=512M /usr/local/bin/wp --allow-root --path="$WP_PATH" "$@"
}

echo "Waiting for MariaDB..."
until mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    sleep 2
done

if [ ! -f "$WP_PATH/wp-settings.php" ]; then
    wp_cli core download
fi

wp_cli config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --skip-check \
    --force

if ! wp_cli core is-installed; then
    wp_cli core install \
        --url="${WP_FULL_URL:-$WP_URL}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
fi

if ! wp_cli user get "$WP_USER" > /dev/null 2>&1; then
    wp_cli user create \
        "$WP_USER" \
        "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role="$WP_ROLE"
fi

if ! wp_cli theme is-installed raft > /dev/null 2>&1; then
    wp_cli theme install raft
fi

wp_cli theme activate raft

chown -R www-data:www-data "$WP_PATH"

exec php-fpm8.2 -F