#!/bin/bash
set -e

INIT_FILE="/var/lib/mysql/init.sql"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld && chmod 750 /run/mysqld

echo "CREATE DATABASE IF NOT EXISTS $WP_DB_NAME;" > $INIT_FILE
echo "CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';" >> $INIT_FILE
echo "GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%';" >> $INIT_FILE
echo "FLUSH PRIVILEGES;" >> $INIT_FILE

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysqld --initialize-insecure --user=mysql --datadir="/var/lib/mysql"
fi

exec "mysqld_safe"
