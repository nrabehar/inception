FROM debian:bullseye-slim
LABEL maintainer="nrabehar <nrabehar@student.42antananarivo.mg>"

# Install MariaDB
RUN apt-get update && \
    apt-get install -y \
        mariadb-server \
        mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create directories for MariaDB
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld

# Copy MariaDB configuration
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY conf/init.sql /docker-entrypoint-initdb.d/init.sql

# Copy entrypoint script
COPY conf/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set proper permissions
RUN chown -R mysql:mysql /var/lib/mysql && \
    chmod -R 755 /var/lib/mysql

# Expose MariaDB port
EXPOSE 3306

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Start MariaDB
CMD ["mysqld", "--user=mysql", "--console"]
