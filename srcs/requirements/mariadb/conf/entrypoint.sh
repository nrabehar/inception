#!/bin/bash
set -e

echo "🗄️  Starting MariaDB setup..."

# Create log directory
mkdir -p /var/log/mysql
chown mysql:mysql /var/log/mysql

# Initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "📦 Initializing MariaDB database..."

    # Initialize the database
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily for setup
    mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < /docker-entrypoint-initdb.d/init.sql

    echo "✅ MariaDB database initialized!"
else
    echo "✅ MariaDB database already exists, skipping initialization..."
fi

# Set proper permissions
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld

echo "🎉 MariaDB setup complete! Starting server..."

# Execute the main command
exec "$@"
