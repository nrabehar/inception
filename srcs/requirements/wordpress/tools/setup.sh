#!/bin/bash
set -e

WP_PATH="/var/www/html/wp"

already_exists=$(ls -A $WP_PATH 2>/dev/null) || true

if [ "$already_exists" ]; then
		exec "$@"
fi

if [ -z "$WP_DATABASE_NAME" ] || [ -z "$WP_DATABASE_USER" ] || [ -z "$WP_DATABASE_PASSWORD" ]; then
		echo "Error: database credentials are not set."
		exit 1
fi

if [ -z "$WP_ADMIN_EMAIL" ] || [ -z "$WP_ADMIN_USER" ] || [ -z "$WP_ADMIN_PASSWORD" ]; then
		echo "Error: admin credentials are not set."
		exit 1
fi

if [ -z "$WP_SITE_NAME" ]; then
		WP_SITE_NAME="WordPress"
fi

if [ -z "$WP_SITE_URL" ]; then
		WP_SITE_URL="http://localhost"
fi

wp core download --allow-root
wp config create --dbname=$WP_DATABASE_NAME \
	--dbuser=$WP_DATABASE_USER \
	--dbpass=$WP_DATABASE_PASSWORD \
	--dbhost=$DB_HOST \
	--allow-root
wp core install --url=$WP_SITE_URL \
	--title="$WP_SITE_NAME" \
	--admin_user=$WP_ADMIN_USER \
	--admin_password=$WP_ADMIN_PASSWORD \
	--admin_email=$WP_ADMIN_EMAIL \
	--allow-root
wp user create $WP_USER_NAME $WP_USER_EMAIL \
	--role=administrator \
	--user_pass=$WP_USER_PASSWORD \
	--allow-root

wp theme install twentytwentyone --activate --allow-root
wp plugin install redis-cache --activate --allow-root

wp config set WP_REDIS_HOST $REDIS_HOST --allow-root
wp config set WP_REDIS_PORT $REDIS_PORT --allow-root
wp config set WP_REDIS_PREFIX $REDIS_PREFIX --allow-root
wp config set WP_CACHE true --allow-root

wp plugin update --all --allow-root
wp redis enable --allow-root

chown -R www-data:www-data $WP_PATH
chmod -R 755 $WP_PATH

exec "$@"