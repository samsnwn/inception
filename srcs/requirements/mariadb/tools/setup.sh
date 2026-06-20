#!/bin/bash

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_PASS_ROOT=$(cat /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

mysqld_safe --user=mysql &

until mariadb-admin ping --silent; do
    sleep 1
done

if mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; then
    MYSQL_CMD="mariadb -u root"
else
    MYSQL_CMD="mariadb -u root -p${DB_PASS_ROOT}"
fi

$MYSQL_CMD << EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

CREATE USER IF NOT EXISTS '${DB_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

ALTER USER '${DB_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';

ALTER USER 'root'@'localhost'
IDENTIFIED BY '${DB_PASS_ROOT}';

FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${DB_PASS_ROOT}" shutdown

exec "$@"