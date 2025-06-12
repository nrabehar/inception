#!/bin/bash
set -e

CONFIG_PATH="/etc/mysql/mariadb.conf.d/50-server.cnf"

DB_ROOT_PASSWORD="root"
WP_DATABASE_NAME="wordpress"
WP_DATABASE_USER="wp-user"
WP_DATABASE_PASSWORD="wp-password"

sed -i "s|bind-address.*|bind-address = 0.0.0.0|" $CONFIG_PATH

mysqld_safe --skip-networking &

until mysqladmin ping --silent; do
		echo "Waiting for MariaDB to start..."
		sleep 1
done

mysql -uroot -p$DB_ROOT_PASSWORD <<-EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
	CREATE DATABASE IF NOT EXISTS $WP_DATABASE_NAME;
	CREATE USER IF NOT EXISTS '$WP_DATABASE_USER'@'%' IDENTIFIED BY '$WP_DATABASE_PASSWORD';
	GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO '$WP_DATABASE_USER'@'%' IDENTIFIED BY '$WP_DATABASE_PASSWORD';
	FLUSH PRIVILEGES;
EOSQL

mysqladmin -uroot -p$DB_ROOT_PASSWORD shutdown

exec "$@"