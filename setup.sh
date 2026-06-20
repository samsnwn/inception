#!/bin/bash

echo "🚀 Generating secure random passwords and .env file for Inception..."

# Generate random passwords
WP_ADMIN_PASSWORD=$(openssl rand -base64 12)
WP_PASSWORD=$(openssl rand -base64 12)
DB_PASSWORD=$(openssl rand -base64 12)
DB_ROOT_PASSWORD=$(openssl rand -base64 12)

# 1. Create the .env file in the srcs/ directory
mkdir -p srcs
cat << EOF > srcs/.env
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

printf "WP_ADMIN_PASSWORD=%s\nWP_PASSWORD=%s" "$WP_ADMIN_PASSWORD" "$WP_PASSWORD" > secrets/credentials.txt
printf "%s" "$DB_PASSWORD" > secrets/db_password.txt
printf "%s" "$DB_ROOT_PASSWORD" > secrets/db_root_password.txt

echo "✅ Successfully created srcs/.env and secrets/ files!"
echo ""
echo "⚠️  IMPORTANT: Save these generated passwords for your evaluation ⚠️"
echo "WordPress Admin (super) Password: $WP_ADMIN_PASSWORD"
echo "WordPress User (sam) Password: $WP_PASSWORD"
echo "Database Password: $DB_PASSWORD"
echo "Database Root Password: $DB_ROOT_PASSWORD"
echo "--------------------------------------------------------"
echo "You can now run 'make' safely."
