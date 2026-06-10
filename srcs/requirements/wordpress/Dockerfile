# Base image: Debian 12 (Bookworm) slim version
FROM debian:bookworm-slim

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Update package lists and install PHP-FPM, MariaDB client, and necessary tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    php-fpm \
    php-mysql \
    mariadb-client \
    wget \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create directories for PHP runtime and WordPress installation
RUN mkdir -p /run/php \
    && mkdir -p /var/run/php \
    && mkdir -p /var/www/inception
# Create a symbolic link for the inception directory
RUN ln -sfn /var/www/inception /var/inception

# Copy PHP-FPM pool configuration and WordPress configuration template
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/wp-config.php /tmp/wp-config.php
# Copy setup script to the container
COPY tools/setup.sh /bin/setup.sh

# Make the setup script executable
RUN chmod +x /bin/setup.sh

# Configure PHP-FPM: disable cgi.fix_pathinfo for security and set listen port to 9000
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/8.2/fpm/php.ini && \
    sed -i 's|listen = .*|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

# Download and install WP-CLI (WordPress Command Line Interface)
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Ensure www-data user has ownership of the WordPress directory
RUN chown -R www-data:www-data /var/www/inception

# Set the working directory to the WordPress installation path
WORKDIR /var/www/inception

# Set the setup script as the entrypoint
ENTRYPOINT ["/bin/setup.sh"]
# Start PHP-FPM in the foreground
CMD ["php-fpm8.2", "-F"]