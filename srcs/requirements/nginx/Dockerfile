FROM debian:bullseye-slim

RUN apt-get update && \
	apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/certs && \
		mkdir -p /var/www/html
RUN echo "Welcome to Nginx on 42Antananarivo!" > /var/www/html/index.html

COPY ./conf/nginx.conf /etc/nginx/sites-available/default
RUN chmod 644 /etc/nginx/sites-available/default

COPY ./tools/setup.sh /tmp/setup.sh
COPY ./tools/ssl.sh /tmp/ssl.sh
RUN chmod +x /tmp/setup.sh
RUN chmod +x /tmp/ssl.sh

EXPOSE 443

ENTRYPOINT [ "/tmp/setup.sh" ]

CMD ["nginx", "-g", "daemon off;"]