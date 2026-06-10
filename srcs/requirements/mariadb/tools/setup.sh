#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure runtime directory exists (socket/pid) and set correct permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql || true

# Start the server temporarily to apply idempotent provisioning statements
service mariadb start || true

# Idempotent SQL: run on every container start to ensure DB, users, and privileges exist
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
FLUSH PRIVILEGES;
EOF

# Give MariaDB a moment to apply all changes smoothly
sleep 2

# Stop the temporary MariaDB instance so it can be restarted in the foreground
service mariadb stop || true

# Exec the final command (starts the DB in foreground to keep the container running)
exec "$@"