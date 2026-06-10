# Base image: Debian 12 (Bookworm) slim version
FROM debian:bookworm-slim

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Update package lists and install NGINX and OpenSSL
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Define build arguments for SSL certificate generation
ARG	CERT_FOLDER CERTIFICATE KEY COUNTRY STATE LOCALITY ORGANIZATION UNIT COMMON_NAME

# Create certificate directory and generate self-signed SSL certificate
RUN mkdir -p "$CERT_FOLDER" && \
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout "$KEY" \
    -out "$CERTIFICATE" \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$UNIT/CN=$COMMON_NAME"

# Copy NGINX main and server configurations
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/server.conf /etc/nginx/conf.d/server.conf

# Configure server_name and SSL certificate paths in the NGINX configuration
RUN sed -i "s|^server_name .*;|server_name ${COMMON_NAME};|" /etc/nginx/conf.d/server.conf && \
    sed -i "s|^ssl_certificate .*;|ssl_certificate ${CERTIFICATE};|" /etc/nginx/conf.d/server.conf && \
    sed -i "s|^ssl_certificate_key .*;|ssl_certificate_key ${KEY};|" /etc/nginx/conf.d/server.conf

# Create web root directory
RUN		mkdir -p /var/www/
# Ensure www-data user has ownership of the web root
RUN		chown -R www-data:www-data /var/www/

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]