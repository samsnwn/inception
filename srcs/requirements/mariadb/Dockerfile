# Debian 12 bookworm image
FROM 	debian:bookworm-slim

# Container will listen on port 3306
EXPOSE 	3306

# System update and mariaDB install. rm is used to clean the apt cache.
RUN		apt update && \
		apt install -y --no-install-recommends --no-install-suggests \
		mariadb-server && \
		rm -rf /var/lib/apt/lists/*

# Configure MariaDB to listen on all network interfaces
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# MariaDB needs a writable runtime directory for its socket and pid file.
RUN		mkdir -p /run/mysqld && \
		chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy config file into container.
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copy setup script to container and change permissions
COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

# Execute setup script, then start db server.
CMD		[ "setup.sh", "mysqld_safe" ]