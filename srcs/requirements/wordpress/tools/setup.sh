#!/bin/bash

# Create the WordPress directory and set ownership to the web server user
mkdir -p /var/www/inception/
chown -R www-data:www-data /var/www/inception/

# Move the wp-config.php template into the WordPress directory if it doesn't already exist
if [ ! -f "/var/www/inception/wp-config.php" ]; then
   mv /tmp/wp-config.php /var/www/inception/
fi

# Wait a few seconds to ensure the MariaDB database is fully initialized and accepting connections
sleep 10

# Download the core WordPress files
wp --allow-root --path="/var/www/inception/" core download || true

# Check if WordPress is already installed; if not, run the installation process
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

# Check if the specific user exists; if not, create the user with given credentials
if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER;
then
    wp  --allow-root --path="/var/www/inception/" user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=$WP_ROLE
fi;

# Install and activate the designated WordPress theme
wp --allow-root --path="/var/www/inception/" theme install raft --activate

# Replace the shell process with the actual command provided via Docker CMD
exec "$@"