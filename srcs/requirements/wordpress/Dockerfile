FROM debian:bookworm-slim

EXPOSE 9000

RUN apt-get update && apt-get install -y --no-install-recommends \
    php-fpm \
    php-mysql \
    mariadb-client \
    wget \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php \
    && mkdir -p /var/run/php \
    && mkdir -p /var/www/inception
RUN ln -sfn /var/www/inception /var/inception

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/wp-config.php /tmp/wp-config.php
COPY tools/setup.sh /bin/setup.sh

RUN chmod +x /bin/setup.sh

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/8.2/fpm/php.ini && \
    sed -i 's|listen = .*|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN chown -R www-data:www-data /var/www/inception

WORKDIR /var/www/inception

ENTRYPOINT ["/bin/setup.sh"]
CMD ["php-fpm8.2", "-F"]