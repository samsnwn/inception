#!/bin/bash

set -e

# Ensure runtime directory exists (socket/pid)
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql || true

# Start the server temporarily to apply idempotent provisioning statements.
service mariadb start || true

DB_NAME=thedatabase
DB_USER=theuser
DB_PASSWORD=abc
DB_PASS_ROOT=123

# Idempotent SQL: safe to run on every container start.
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
FLUSH PRIVILEGES;
EOF

sleep 2
service mariadb stop || true

# Exec the final command (starts the DB in foreground)
exec "$@"