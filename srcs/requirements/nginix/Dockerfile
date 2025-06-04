FROM    debian:bullseye-slim
LABEL   maintainer="nrabehar <nrabehar@student.42antananarivo.mg"

RUN apt-get update && \
		apt-get install -y nginx openssl && \
		apt-get clean && \
		rm -rf /var/lib/apt/lists/*

# Create SSL directories
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Generate self-signed SSL certificate for nrabehar.42.fr
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=MG/ST=Antananarivo/L=Antananarivo/O=42School/CN=nrabehar.42.fr"

# Set proper permissions for SSL files
RUN chmod 600 /etc/ssl/private/nginx.key && \
    chmod 644 /etc/ssl/certs/nginx.crt

# Copy nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create web directory
RUN mkdir -p /var/www/html

# Create a simple index page
RUN echo '<html><head><title>Welcome to nrabehar.42.fr</title></head><body><h1>HTTPS Only - TLSv1.3</h1><p>Welcome to nrabehar.42.fr running on nginx with TLSv1.3!</p></body></html>' > /var/www/html/index.html

# Expose only port 443 (HTTPS)
EXPOSE 443

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
