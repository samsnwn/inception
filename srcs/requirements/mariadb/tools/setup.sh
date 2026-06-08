#!/bin/bash

# this script run in the building container
# it creates start the mariadb service and create the database and users according to the .env file
# at the end, exec $@ run the next CMD in the Dockerfile.
# In this case: "mysqld_safe" that restart the mariadb service

set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql
chmod 755 /run/mysqld

mariadb_root() {
    mariadb -uroot -p"$DB_PASS_ROOT" "$@" 2>/dev/null || mariadb "$@"
}

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    service mariadb start

    service mariadb stop
fi

service mariadb start

mariadb_root -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
mariadb_root -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mariadb_root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASS_ROOT}';"
mariadb_root -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';"
mariadb_root -e "FLUSH PRIVILEGES;"

exec mariadbd --user=mysql --datadir=/var/lib/mysql