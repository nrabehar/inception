FROM debian:bookworm-slim

RUN apt-get update && \
	apt-get install -y nginx openssl procps

RUN mkdir -p /etc/nginx/certs && \
		mkdir -p /var/www/html

COPY ./conf/nginx.conf /etc/nginx/sites-available/default
RUN chmod 644 /etc/nginx/sites-available/default

COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 443

ENTRYPOINT [ "/tmp/setup.sh" ]