FROM debian:bookworm-slim

EXPOSE 443

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG	CERT_FOLDER=/etc/nginx/certs/
ARG	CERTIFICATE=/etc/nginx/certs/certificate.crt
ARG	KEY=/etc/nginx/certs/certificate.key
ARG	COUNTRY=BR
ARG	STATE=BA
ARG	LOCALITY=Salvador
ARG	ORGANIZATION=42
ARG	UNIT=42
ARG	COMMON_NAME=login.42.fr

ARG	CERT_FOLDER CERTIFICATE KEY COUNTRY STATE LOCALITY ORGANIZATION UNIT COMMON_NAME

RUN mkdir -p "$CERT_FOLDER" && \
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout "$KEY" \
    -out "$CERTIFICATE" \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$UNIT/CN=$COMMON_NAME"

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/server.conf /etc/nginx/conf.d/server.conf

RUN		echo "\tserver name ${COMMON_NAME};\n\
			\tssl_certificate ${CERTIFICATE};\n\
			\tssl_certificate_key ${KEY};\n\
			}" >> /etc/nginx/conf.d/server.conf

RUN		mkdir -p /var/www/
RUN		chown -R www-data:www-data /var/www/

CMD ["nginx", "-g", "daemon off;"]