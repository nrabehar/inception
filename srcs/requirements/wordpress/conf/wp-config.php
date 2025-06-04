<?php
/**
 * WordPress configuration file for Inception project
 * nrabehar@student.42antananarivo.mg
 */

// ** MySQL settings ** //
define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wpuser');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'wppassword');
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'mariadb:3306');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// ** Authentication Unique Keys and Salts ** //
define('AUTH_KEY',         'inception-auth-key-nrabehar-42');
define('SECURE_AUTH_KEY',  'inception-secure-auth-key-nrabehar-42');
define('LOGGED_IN_KEY',    'inception-logged-in-key-nrabehar-42');
define('NONCE_KEY',        'inception-nonce-key-nrabehar-42');
define('AUTH_SALT',        'inception-auth-salt-nrabehar-42');
define('SECURE_AUTH_SALT', 'inception-secure-auth-salt-nrabehar-42');
define('LOGGED_IN_SALT',   'inception-logged-in-salt-nrabehar-42');
define('NONCE_SALT',       'inception-nonce-salt-nrabehar-42');

// ** WordPress Database Table prefix ** //
$table_prefix = 'wp_';

// ** WordPress debugging ** //
define('WP_DEBUG', false);
define('WP_DEBUG_LOG', false);
define('WP_DEBUG_DISPLAY', false);

// ** HTTPS and Security ** //
define('FORCE_SSL_ADMIN', true);
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

// ** WordPress URLs ** //
define('WP_HOME', 'https://nrabehar.42.fr');
define('WP_SITEURL', 'https://nrabehar.42.fr');

// ** File permissions ** //
define('FS_METHOD', 'direct');

// ** Memory limit ** //
define('WP_MEMORY_LIMIT', '256M');

// ** Disable file editing ** //
define('DISALLOW_FILE_EDIT', true);

// ** Automatic updates ** //
define('WP_AUTO_UPDATE_CORE', false);

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
