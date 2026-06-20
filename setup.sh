#!/bin/bash

echo "🚀 Generating secrets and .env file for Inception..."

# 1. Create the .env file in the srcs/ directory
mkdir -p srcs
cat << 'EOF' > srcs/.env
DB_NAME=mydb
DB_USER=sam
DB_HOST=mariadb

WP_URL=samcasti.42.fr
WP_TITLE=Inception
WP_ADMIN_USER=super
WP_ADMIN_EMAIL=super@123.com
WP_USER=sam
WP_EMAIL=sam@123.com
WP_ROLE=editor
WP_FULL_URL=https://samcasti.42.fr

CERT_FOLDER=/etc/nginx/certs
CERTIFICATE=/etc/nginx/certs/certificate.crt
KEY=/etc/nginx/certs/certificate.key
COUNTRY=DE
STATE=Berlin
LOCALITY=Berlin
ORGANIZATION=42
UNIT=42
COMMON_NAME=samcasti.42.fr
EOF

# 2. Create the secrets directory and the password files
mkdir -p secrets

printf "WP_ADMIN_PASSWORD=123\nWP_PASSWORD=abc" > secrets/credentials.txt
printf "abc" > secrets/db_password.txt
printf "123" > secrets/db_root_password.txt

echo "✅ Successfully created srcs/.env and secrets/ files!"
echo "You can now run 'make' safely."
