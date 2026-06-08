<?php

define('DB_NAME', getenv('DB_NAME') ?: 'maria');
define('DB_USER', getenv('DB_USER') ?: 'sam');
define('DB_PASSWORD', getenv('DB_PASSWORD') ?: 'abc');
define('DB_HOST', getenv('DB_HOST') ?: 'mariadb');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('WP_HOME', getenv('WP_FULL_URL') ?: 'https://localhost:8443');
define('WP_SITEURL', getenv('WP_FULL_URL') ?: 'https://localhost:8443');

define('AUTH_KEY',         'change-me-auth-key');
define('SECURE_AUTH_KEY',  'change-me-secure-auth-key');
define('LOGGED_IN_KEY',    'change-me-logged-in-key');
define('NONCE_KEY',        'change-me-nonce-key');
define('AUTH_SALT',        'change-me-auth-salt');
define('SECURE_AUTH_SALT', 'change-me-secure-auth-salt');
define('LOGGED_IN_SALT',   'change-me-logged-in-salt');
define('NONCE_SALT',       'change-me-nonce-salt');

$table_prefix = 'wp_';

if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}

require_once( ABSPATH . 'wp-settings.php' );
