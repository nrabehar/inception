#!/bin/bash
set -e

echo "🚀 Starting WordPress with PHP-FPM setup..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
    echo "Database not ready, waiting..."
    sleep 2
done
echo "✅ Database connection established!"

# Check if WordPress is already installed
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "📦 Installing WordPress..."

    # Install WordPress
    wp core install \
        --url="https://nrabehar.42.fr" \
        --title="Inception WordPress - nrabehar.42.fr" \
        --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin123}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL:-nrabehar@student.42antananarivo.mg}" \
        --allow-root

    # Create additional user if specified
    if [ -n "$WORDPRESS_USER" ] && [ -n "$WORDPRESS_PASSWORD" ]; then
        echo "👤 Creating additional WordPress user..."
        wp user create \
            "$WORDPRESS_USER" \
            "${WORDPRESS_USER_EMAIL:-user@nrabehar.42.fr}" \
            --user_pass="$WORDPRESS_PASSWORD" \
            --role=author \
            --allow-root
    fi

    # Configure WordPress settings
    echo "⚙️ Configuring WordPress..."

    # Set timezone
    wp option update timezone_string 'Indian/Antananarivo' --allow-root

    # Set date format
    wp option update date_format 'F j, Y' --allow-root

    # Set time format
    wp option update time_format 'g:i a' --allow-root

    # Disable search engine indexing (for dev)
    wp option update blog_public 0 --allow-root

    # Set permalink structure
    wp rewrite structure '/%postname%/' --allow-root

    # Install and activate useful plugins
    echo "🔌 Installing WordPress plugins..."

    # Security plugin
    wp plugin install wordfence --activate --allow-root

    # SEO plugin
    wp plugin install wordpress-seo --activate --allow-root

    # Cache plugin
    wp plugin install w3-total-cache --activate --allow-root

    # Create sample content
    echo "📝 Creating sample content..."

    # Create a sample page
    wp post create \
        --post_type=page \
        --post_title='About Inception Project' \
        --post_content='<h2>Welcome to Inception Project</h2><p>This WordPress site is running in a Docker container with PHP-FPM, configured for HTTPS-only access using TLSv1.3.</p><p><strong>Technologies used:</strong></p><ul><li>Docker & Docker Compose</li><li>Nginx (Reverse Proxy)</li><li>WordPress with PHP-FPM</li><li>MariaDB</li><li>SSL/TLS 1.3</li></ul><p>Created by <strong>nrabehar</strong> - 42 School Antananarivo</p>' \
        --post_status=publish \
        --allow-root

    # Create a sample post
    wp post create \
        --post_title='Hello Inception!' \
        --post_content='<p>Welcome to this WordPress installation running in a secure Docker environment!</p><p>This setup demonstrates:</p><ul><li>✅ HTTPS-only configuration</li><li>✅ TLSv1.3 encryption</li><li>✅ PHP-FPM optimization</li><li>✅ Docker containerization</li><li>✅ MariaDB database</li></ul><p>Project by <em>nrabehar@student.42antananarivo.mg</em></p>' \
        --post_status=publish \
        --allow-root

    echo "✅ WordPress installation completed!"
else
    echo "✅ WordPress already installed, skipping setup..."
fi

# Ensure proper permissions
echo "🔐 Setting file permissions..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chmod 600 /var/www/html/wp-config.php

echo "🎉 WordPress setup complete! Starting PHP-FPM..."

# Execute the main command
exec "$@"
