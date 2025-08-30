FROM debian:bookworm-slim

RUN apt-get update && \
	apt-get install -y php8.2-fpm php8.2-mysql curl\
	php8.2-curl php8.2-dom php8.2-imagick \
	php8.2-mbstring php8.2-zip php8.2-gd php8.2-intl procps

RUN mkdir -p /var/www/html/wp /run/php

WORKDIR /var/www/html/wp

RUN sed -i 's/listen = .*/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 9000

ENTRYPOINT [ "/tmp/setup.sh" ]
