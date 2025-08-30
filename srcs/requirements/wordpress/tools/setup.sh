#!/bin/bash
set -e

WP_PATH="/var/www/html/wp"

already_exists=$(ls -A $WP_PATH 2>/dev/null) || true

if [ "$already_exists" ]; then
		exec "php-fpm8.2" "-F"
fi

if [ -z "$WP_DB_NAME" ] || [ -z "$WP_DB_USER" ] || [ -z "$WP_DB_PASS" ]; then
		echo "Error: database credentials are not set."
		exit 1
fi

if [ -z "$WP_ADMIN_EMAIL" ] || [ -z "$WP_ADMIN_NAME" ] || [ -z "$WP_ADMIN_PASS" ]; then
		echo "Error: admin credentials are not set."
		exit 1
fi

if [ -z "$WP_SITE_NAME" ]; then
		echo "Error: site name is not set."
		exit 1
fi

if [ -z "$WP_SITE_URL" ]; then
		echo "Error: site URL is not set."
		exit 1
fi

wp core download --allow-root
wp config create --dbname=$WP_DB_NAME \
	--dbuser=$WP_DB_USER \
	--dbpass=$WP_DB_PASS \
	--dbhost=$WP_DB_HOST \
	--allow-root
wp core install --url=$WP_SITE_URL \
	--title="$WP_SITE_NAME" \
	--admin_user=$WP_ADMIN_NAME \
	--admin_password=$WP_ADMIN_PASS \
	--admin_email=$WP_ADMIN_EMAIL \
	--allow-root
wp user create $WP_USER_NAME $WP_USER_EMAIL \
	--role=administrator \
	--user_pass=$WP_USER_PASS \
	--allow-root

wp theme install twentytwentyone --activate --allow-root
wp plugin update --all --allow-root

chown -R www-data:www-data $WP_PATH
chmod -R 755 $WP_PATH

exec "php-fpm8.2" "-F"