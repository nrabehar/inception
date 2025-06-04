FROM debian:bullseye-slim
LABEL maintainer="nrabehar <nrabehar@student.42antananarivo.mg>"

# Install PHP-FPM, PHP extensions, and utilities
RUN apt-get update && \
    apt-get install -y \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-curl \
        php7.4-gd \
        php7.4-intl \
        php7.4-mbstring \
        php7.4-soap \
        php7.4-xml \
        php7.4-xmlrpc \
        php7.4-zip \
        php7.4-cli \
        wget \
        curl \
        mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create www-data user directories
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Download and install WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

# Download WP-CLI for WordPress management
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create PHP-FPM run directory
RUN mkdir -p /run/php

# Copy PHP-FPM configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# Copy WordPress configuration
COPY conf/wp-config.php /var/www/html/wp-config.php

# Copy entrypoint script
COPY conf/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
